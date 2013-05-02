//
//  OCExampleResult.m
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

#import "OCExampleResult.h"


@implementation OCExampleResult

@dynamic running;
- (BOOL) isRunning {
	return _startTime != 0 && _stopTime == 0;
}

- (CFTimeInterval) elapsed {
    NSAssert(_startTime > 0, @"Start time not set");
    NSAssert(_stopTime > 0, @"Stop time not set");
	
	CFTimeInterval elapsed = (_stopTime - _startTime);
    NSLog(@"elapsed: %f",elapsed);
    
	return elapsed;
}

+ (id) withExample:(OCExample *)example {
	OCExampleResult *result = [self new];
	result.example = example;
	return result;
}


@end
