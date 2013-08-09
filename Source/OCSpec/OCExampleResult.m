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

- (NSString *) debugDescription {
	return [NSString stringWithFormat:@"%@ %@",[super debugDescription],_example.name];
}

- (NSString *) toHTML {

	NSMutableString *string = [NSMutableString new];
	[string appendFormat:@"<h4>%@</h4>",self.example.name];
	
	[string appendString:@"<ul>"];
	
	[string appendFormat:@"<li>Context: %@</li>",self.context];
	[string appendFormat:@"<li>Elapsed: %@</li>",[NSString stringWithFormat:@"%.2fs",self.elapsed]];
	NSString *statusString = self.success ?  @"[✓] PASS" : @"[X] FAIL";
	[string appendFormat:@"<li>Status: <span style=\"color: %@\">%@</span></li>",(self.success ? @"green" : @"red"),statusString];
	if (self.error) {
		[string appendFormat:@"<li>Error: %@",self.error.name];
		[string appendString:@"<ul>"];
		[string appendFormat:@"<li>Reason: %@</li>",self.error.reason];
		[string appendFormat:@"<li>Info: %@</li>",self.error.userInfo];
		[string appendFormat:@"<li>Trace: <pre>%@</pre></li>",[[self.error callStackSymbols] description]];
		[string appendString:@"</ul></li>"];
	}

	[string appendString:@"</ul>"];

	return string;
}

@end
