//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

«OPTIONALHEADERIMPORTLINE»

#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "OCMock.h"

@implementation «FILEBASENAMEASIDENTIFIER»

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
