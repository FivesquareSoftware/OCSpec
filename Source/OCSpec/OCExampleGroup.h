//
//  OCSpec.h
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

#import "OCSpecRunner.h"
#import "OCExampleResult.h"

@class SpecHelper;

/** Mostly here just to satisfy compiler. */
@protocol OCExampleGroup <NSObject>

@optional
- (void)beforeAll;
- (void)beforeEach;
- (void)afterEach;
- (void)afterAll;

@end

@interface OCExampleGroup : NSObject <OCExampleGroup> 

@property (nonatomic, strong) OCSpecRunner *specRunner;
@property (nonatomic, strong) SpecHelper *specHelper;
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSMutableArray *results;
/// Points the the result for the currently running example, which includes a pointer to the current example
@property (nonatomic, strong) OCExampleResult *currentResult;

+ (NSArray *) subclasses;

/** To support assertion frameworks. */
- (void)failWithException:(NSException *)exception;

- (NSUInteger) numberOfResults;
- (OCExampleResult *) resultAtIndex:(NSUInteger)index;
- (NSUInteger) indexOfResult:(OCExampleResult *)result;
- (void) addResult:(OCExampleResult *)aResult;

- (NSString *) toHTML;

@end


