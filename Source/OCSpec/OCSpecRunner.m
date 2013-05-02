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

NSString *kOCSpecErrorDomain = @"OCSpec Error Domain";

NSString *kOCErrorInfoKeyGroup = @"kOCErrorInfoKeyGroup";

NSString *kOCSpecRunnerNotificationGroupStarted = @"kOCSpecRunnerNotificationGroupStarted";
NSString *kOCSpecRunnerNotificationExampleStarted = @"kOCSpecRunnerNotificationExampleStarted";
NSString *kOCSpecRunnerNotificationExampleFinished = @"kOCSpecRunnerNotificationExampleFinished";
NSString *kOCSpecRunnerNotificationgroupFinished = @"kOCSpecRunnerNotificationgroupFinished";


@implementation OCSpecRunner

- (id) initWithExampleGroups:(NSArray *)someExampleGroups {
    self = [super init];
    if (self != nil) {
        self.exampleGroups = someExampleGroups;
    }
    return self;
}

- (NSMutableArray *) run {
    NSMutableArray *results = [NSMutableArray new];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES];
	NSArray *sortedExampleGroupClasses = [self.exampleGroups sortedArrayUsingDescriptors:@[sortDescriptor]];

	// Loops the groups
	[sortedExampleGroupClasses enumerateObjectsUsingBlock:^(Class groupClass, NSUInteger idx, BOOL *stop) {
        NSLog(@"Running example group: %@",groupClass);
        OCExampleGroup *group;
        @try {
            group = [groupClass new];
			group.index = idx;
			group.specRunner = self;
			
			// Notify delegates group will start
			if ([_delegate respondsToSelector:@selector(exampleGroupDidStart:)]) {
				[_delegate exampleGroupDidStart:group];
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:kOCSpecRunnerNotificationGroupStarted object:group];

			
			// Before All
            if([group respondsToSelector:@selector(beforeAll)]) {
                [group performSelector:@selector(beforeAll)];
            }
			
			//Loop the group methods looking for examples
			NSUInteger exampleIndex = 0;
            unsigned int numMethods;
            Method *methods = class_copyMethodList(groupClass,&numMethods);
			
            for (int i = 0; i < numMethods; i++) {
				
                SEL mSel = method_getName(methods[i]);
                const char *mName = sel_getName(mSel);
                NSString *mString = [NSString stringWithUTF8String:mName];
				// Does the method match a spec selector?
                if([mString rangeOfString:@"should"].location == 0) {
					// Create an example and add it to the group
					OCExample *example = [OCExample withName:mString inGroup:group];
					example.index = exampleIndex++;
					NSLog(@"Running example: %@",example);

					// Set up the result to store the .. result
					OCExampleResult *result = [OCExampleResult  withExample:example];
					[group addResult:result];
					group.currentResult = result;
					[results addObject:result];

					
					// Notifiy delegates we are about to being an example
					if ([_delegate respondsToSelector:@selector(exampleDidStart:)]) {
						[_delegate exampleDidStart:result];
					}					
					[[NSNotificationCenter defaultCenter] postNotificationName:kOCSpecRunnerNotificationExampleStarted object:example];

					// Before Each
                    if([group respondsToSelector:@selector(beforeEach)]){
                        [group performSelector:@selector(beforeEach)];
                    }

                    @try {
						// Run the example
						result.startTime = CFAbsoluteTimeGetCurrent();
//                        [groupInstance performSelector:mSel]; // ARC dislikes this
						objc_msgSend(group,mSel);
						if (NO == result.isDeferred) {
							result.success = YES;
						}
                    }
                    @catch (NSException * e) {
                        NSLog(@"exception: %@",[e name]);
                        NSLog(@"reason: %@",[e reason]);
                        NSLog(@"stack: %@",[e callStackSymbols]);
                        result.error = e;
						result.success = NO;
                    }
                    @finally {
						// An example may actually defer reporting its result state (possibly because it needs to hop off on another thread to wait for a result), if it is done, complete it here
						if (NO == result.isDeferred) {
							[self completeResult:result];
						}
						// After Each
                        if([group respondsToSelector:@selector(afterEach)]) {
                            [group performSelector:@selector(afterEach)];
                        }
                    }
                }
            }
            free(methods);
        }

        @catch (NSException * e) {
            // the whole group failed, spit it out for now I guess
            NSLog(@"%@ could not be run (%@)",groupClass,e);
            NSLog(@"exception: %@",[e name]);
            NSLog(@"reason: %@",[e reason]);
            NSLog(@"stack: %@",[e callStackSymbols]);
			if(_delegate && [_delegate respondsToSelector:@selector(exampleGroupDidFailWithError:)]) {
				NSDictionary *info = @{ kOCErrorInfoKeyGroup : groupClass, NSLocalizedDescriptionKey : [e reason] };
				NSError *error = [NSError errorWithDomain:kOCSpecErrorDomain code:kOCSpecErrorCodeGroupFailed userInfo:info];
				[self.delegate exampleGroupDidFailWithError:error];
			}
        }
        @finally {
            if(group) {
				// Notify delegates group finished
				if ([_delegate respondsToSelector:@selector(exampleGroupDidFinish:)]) {
					[_delegate exampleGroupDidFinish:group];
				}
				[[NSNotificationCenter defaultCenter] postNotificationName:kOCSpecRunnerNotificationgroupFinished object:group];

				// After All
                if([group respondsToSelector:@selector(afterAll)]) {
                    @try {
                        [group performSelector:@selector(afterAll)];
                    }
                    @catch (NSException * e) {
                        NSLog(@"Error running %@.afterAll (%@)",groupClass,e);
                        if(_delegate && [_delegate respondsToSelector:@selector(exampleGroupDidFailWithError:)]) {
							NSDictionary *info = @{ kOCErrorInfoKeyGroup : groupClass, NSLocalizedDescriptionKey : [e reason] };
							NSError *error = [NSError errorWithDomain:kOCSpecErrorDomain code:kOCSpecErrorCodeAfterAllFailed userInfo:info];
                            [self.delegate exampleGroupDidFailWithError:error];
                        }
                    }
                }
                group = nil;
            }
        }
	}];
    return results;
}

- (void) deferResult:(OCExampleResult *)result untilDone:(void(^)())exampleBlock {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		result.deferred = YES;
		@try {
			exampleBlock();
			result.success = YES;
			result.deferred = NO;
		}
		@catch (NSException * e) {
			NSLog(@"exception: %@",[e name]);
			NSLog(@"reason: %@",[e reason]);
			NSLog(@"stack: %@",[e callStackSymbols]);
			result.error = e;
			result.success = NO;
		}
		@finally {
			[self completeResult:result];
		}
	});
}

- (void) completeResult:(OCExampleResult *)result {
	result.stopTime = CFAbsoluteTimeGetCurrent();
	[[NSNotificationCenter defaultCenter] postNotificationName:kOCSpecRunnerNotificationExampleFinished object:result];
	if(_delegate && [_delegate respondsToSelector:@selector(exampleDidFinish:)]) {
		[self.delegate exampleDidFinish:result];
	}
}


@end



