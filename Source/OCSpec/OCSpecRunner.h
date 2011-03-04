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

@class OCExampleResult;

extern NSString *kOCErrorInfoKeyGroup;
extern NSString *kOCErrorInfoKeyMessage;

@protocol OCSpecRunnerDelegate<NSObject>
@optional
- (void) exampleDidFinish:(OCExampleResult *)result;
- (void) errorRunningGroup:(NSDictionary *)errorInfo;
@end


@interface OCSpecRunner : NSObject {
    NSArray *exampleGroups;
    id<OCSpecRunnerDelegate> delegate;
    unsigned long long startTime;
    unsigned long long stopTime;
}

@property (nonatomic, retain) NSArray *exampleGroups;
@property (nonatomic, assign) id<OCSpecRunnerDelegate> delegate;
@property (nonatomic, assign) unsigned long long startTime;
@property (nonatomic, assign) unsigned long long stopTime;

- (id) initWithExampleGroups:(NSArray *)someExampleGroups;

- (NSMutableArray *) run;
- (void) startBenchmark;
- (void) stopBenchmark;
- (long) elapsed;
- (unsigned long long) currentMilliseconds;

@end
