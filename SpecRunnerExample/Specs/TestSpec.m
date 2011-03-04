//
//  TestSpec.m
//  SpecRunnerExample
//
//  Created by John Clayton on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestSpec.h"

@implementation TestSpec

+ (NSString *)description {
    return @"Some description of this example group";
}

- (void)beforeAll {
    // set up resources common to all examples here
}

- (void)beforeEach {
    // set up resources that need to be initialized before each example here 
}

- (void)shouldDoSomething {
    NSAssert(NO,@"Doesn't do anything");
}


- (void)afterEach {
    // tear down resources specific to each example here
}


- (void)afterAll {
    // tear down common resources here
}

@end
