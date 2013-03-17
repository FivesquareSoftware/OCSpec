//
//  SpecRunner.m
//  SpecRunner
//
//  Created by John Clayton on 12/23/2008.
//  Copyright 2008 Fivesquare Software, LLC. All rights reserved.
//

/* 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE. */

#import "OCSpecRunner.h"

#import "OCExampleGroup.h"
#import "OCExampleResult.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import <objc/message.h>

#include <sys/time.h>
#include "limits.h"


NSString *kOCErrorInfoKeyGroup = @"kOCErrorInfoKeyGroup";
NSString *kOCErrorInfoKeyMessage = @"kOCErrorInfoKeyMessage";


@interface OCSpecRunner()
@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CFAbsoluteTime stopTime;
- (CFTimeInterval) elapsed;

@end


@implementation OCSpecRunner

@synthesize exampleGroups=exampleGroups_;
@synthesize delegate=delegate_;
@synthesize startTime=startTime_, stopTime=stopTime_;


- (id) initWithExampleGroups:(NSArray *)someExampleGroups {
    self = [super init];
    if (self != nil) {
        self.exampleGroups = someExampleGroups;
    }
    return self;
}



- (NSMutableArray *) run {
    NSMutableArray *results = [NSMutableArray new];
    OCExampleResult *result;
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES];
	NSArray *sortedExampleGroups = [self.exampleGroups sortedArrayUsingDescriptors:@[sortDescriptor]];
    for (Class group in sortedExampleGroups) {
        NSLog(@"Running example group: %@",group);
        OCExampleGroup *groupInstance;
        @try {
            groupInstance = [group new];
            if([groupInstance respondsToSelector:@selector(beforeAll)]) {
                [groupInstance performSelector:@selector(beforeAll)];
            }
            unsigned int numMethods;
            Method *methods = class_copyMethodList(group,&numMethods);
            for (int i = 0; i < numMethods; i++) {
                SEL mSel = method_getName(methods[i]);
                const char *mName = sel_getName(mSel);
                NSString *mString = [NSString stringWithUTF8String:mName];
                if([mString rangeOfString:@"should"].location == 0) {
                    NSLog(@"Running example: %@",mString);
                    if([groupInstance respondsToSelector:@selector(beforeEach)]){
                        [groupInstance performSelector:@selector(beforeEach)];
                    }
                    @try {
                        result = [[OCExampleResult alloc] initWithExampleName:mString inGroup:group];
						groupInstance.result = result;
						startTime_ = CFAbsoluteTimeGetCurrent();
//                        [groupInstance performSelector:mSel]; // ARC dislikes this
						objc_msgSend(groupInstance,mSel);
                        result.success = YES;
                    }
                    @catch (NSException * e) {
                        NSLog(@"exception: %@",[e name]);
                        NSLog(@"reason: %@",[e reason]);
                        NSLog(@"stack: %@",[e callStackSymbols]);
                        result.success = NO;
                        result.error = e;
                    }
                    @finally {
						stopTime_ = CFAbsoluteTimeGetCurrent();
                        result.elapsed = [self elapsed];
                        if([groupInstance respondsToSelector:@selector(afterEach)]) {
                            [groupInstance performSelector:@selector(afterEach)];
                        }
                        [results addObject:result];
                        if(delegate_ && [delegate_ respondsToSelector:@selector(exampleDidFinish:)]) {
                            [self.delegate exampleDidFinish:result];
                        }
                    }
                }
            }
            free(methods);
        }
        @catch (NSException * e) {
            // the whole group failed, spit it out for now I guess
            NSLog(@"%@ could not be run (%@)",group,e);
            NSLog(@"exception: %@",[e name]);
            NSLog(@"reason: %@",[e reason]);
            NSLog(@"stack: %@",[e callStackSymbols]);
			if(delegate_ && [delegate_ respondsToSelector:@selector(errorRunningGroup:)]) {
				[self.delegate errorRunningGroup:[NSDictionary dictionaryWithObjectsAndKeys:group,kOCErrorInfoKeyGroup,[e reason],kOCErrorInfoKeyMessage,nil]];
			}
        }
        @finally {
            if(groupInstance) {
                if([groupInstance respondsToSelector:@selector(afterAll)]) {
                    @try {
                        [groupInstance performSelector:@selector(afterAll)];
                    }
                    @catch (NSException * e) {
                        NSLog(@"Error running %@.afterAll (%@)",group,e);
                        if(delegate_ && [delegate_ respondsToSelector:@selector(errorRunningGroup:)]) {
                            [self.delegate errorRunningGroup:[NSDictionary dictionaryWithObjectsAndKeys:group,kOCErrorInfoKeyGroup,[e reason],kOCErrorInfoKeyMessage,nil]];
                        }
                    }
                }
                groupInstance = nil;
            }
        }
    }
    return results;
}

- (CFTimeInterval) elapsed {
    NSAssert(startTime_ > 0, @"Start time not set");
    NSAssert(stopTime_ > 0, @"Stop time not set");    

	CFTimeInterval elapsed = (stopTime_ - startTime_);
    NSLog(@"elapsed: %f",elapsed);

    startTime_ = 0;
    stopTime_ = 0;
    
	return elapsed;
}


@end



