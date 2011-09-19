//
//  OCSpec.m
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

#import "OCExampleGroup.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>


static NSMutableArray *subclasses = nil;

@implementation OCExampleGroup

@synthesize specHelper=specHelper_;

- (SpecHelper *) specHelper {
	if(specHelper_ == nil) {
		Class klass;
		if( (klass = NSClassFromString(@"SpecHelper")) ) {
			specHelper_ = [klass new];
		}
	}
	return specHelper_;
}



+ (NSArray *) groups {
    if(subclasses == nil) {
        subclasses = [NSMutableArray new];
        int numClasses;
        Class *classes;
        
        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        
        if (numClasses > 0 ) {
            classes = (Class *)malloc((sizeof(Class)) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                Class klass = classes[i];
				NSString *className = NSStringFromClass(klass);
				if([className rangeOfString:@"Spec"].location != NSNotFound)
					NSLog(@"klass: %@", className);
                if(class_getSuperclass(klass) == [OCExampleGroup class]) {
                    [subclasses addObject:klass];
                }
            }
            free(classes);
        }
    }
    return subclasses;
}

- (void)failWithException:(NSException *)exception {
	@throw exception;
}

@end
