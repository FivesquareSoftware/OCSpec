//
//	GroupResults.m
//	SpecRunner
//
//	Created by John Clayton on 12/24/2008.
//	Copyright 2008 Fivesquare Software, LLC. All rights reserved.
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

#import "SpecRunnerGroupResults.h"

#import "OCSpec.h"


@implementation SpecRunnerGroupResults

@synthesize group=group_;
@synthesize results=results_;

- (id) initWithGroup:(Class)aGroup {
	self = [super init];
	if (self != nil) {
		group_ = aGroup;
		results_ = [NSMutableArray new];
	}
	return self;
}

+ (id) withGroup:(Class)aGroup {
	return [[SpecRunnerGroupResults alloc] initWithGroup:aGroup];
}


- (NSUInteger) hash {
	return [self.group hash];
}

- (BOOL) isEqual:(id)otherObject {
	if(![otherObject respondsToSelector:@selector(group)]) 
		return NO; 
	else
		return self.group == [otherObject performSelector:@selector(group)];
}

- (NSString *) description {
	return [self.group description];
}

- (NSUInteger) numberOfResults {
	return [self.results count];
}

- (OCExampleResult *) resultAtIndex:(NSUInteger)index {
	return [self.results objectAtIndex:index];
}

- (void) addResult:(OCExampleResult *)aResult {
	[self.results addObject:aResult];
}


@end
