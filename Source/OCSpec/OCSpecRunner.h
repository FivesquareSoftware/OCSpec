//
//  SpecRunner.h
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

#import <Foundation/Foundation.h>

@class OCExampleGroup;
@class OCExample;
@class OCExampleResult;

extern NSString *kOCSpecErrorDomain;
enum {
	kOCSpecErrorCodeGroupFailed = 1000,
	kOCSpecErrorCodeAfterAllFailed = 1001
};

extern NSString *kOCErrorInfoKeyGroup;

extern NSString *kOCSpecRunnerNotificationGroupStarted;
extern NSString *kOCSpecRunnerNotificationExampleStarted;
extern NSString *kOCSpecRunnerNotificationExampleFinished;
extern NSString *kOCSpecRunnerNotificationgroupFinished;

@protocol OCSpecRunnerDelegate<NSObject>
@optional
- (void) exampleGroupDidStart:(OCExampleGroup *)group;
- (void) exampleDidStart:(OCExampleResult *)result;
- (void) exampleDidFinish:(OCExampleResult *)result;
- (void) exampleGroupDidFinish:(OCExampleGroup *)group;
- (void) exampleGroupDidFailWithError:(NSError *)error;
@end


@interface OCSpecRunner : NSObject

@property (nonatomic, strong) NSArray *exampleGroups;
@property (nonatomic, weak) id<OCSpecRunnerDelegate> delegate;

- (id) initWithExampleGroups:(NSArray *)someExampleGroups;

- (NSSet *) run;
- (void) deferResult:(OCExampleResult *)result untilDone:(void(^)())exampleBlock;

@end
