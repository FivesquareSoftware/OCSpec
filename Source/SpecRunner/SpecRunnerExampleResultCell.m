//
//	SpecRunnerExampleResultCell.m
//	SpecRunner
//
//	Created by John Clayton on 12/23/2008.
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

#import "SpecRunnerExampleResultCell.h"


#import <CoreGraphics/CoreGraphics.h>


@interface SpecRunnerExampleResultCell()
- (UIImage *) statusImageForResult:(OCExampleResult *)aResult;
@end


@implementation SpecRunnerExampleResultCell


@synthesize result;
@synthesize statusImage;

- (void) setResult:(OCExampleResult *)newResult {
	if(result != newResult){
		result = newResult;
		self.textLabel.text = result.exampleName;
		
		[statusImage release]; statusImage = nil;
		
		self.imageView.image = self.statusImage;
	}
}

- (UIImage *) statusImage {
	if(statusImage == nil) {
		statusImage = [[self statusImageForResult:self.result] retain];
	}
	return statusImage;
}

- (void) dealloc {
	[statusImage release]; statusImage = nil;
	[super dealloc];
}


- (UIImage *) statusImageForResult:(OCExampleResult *)aResult {
	if([NSThread currentThread] != [NSThread mainThread]) {
		[self performSelectorOnMainThread:_cmd withObject:aResult waitUntilDone:YES];
	}
	
	CGRect imageViewRect = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
	UIGraphicsBeginImageContext(imageViewRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint imageViewCenter = CGPointMake(CGRectGetMidX(imageViewRect), CGRectGetMidY(imageViewRect));
	CGRect imageRect = CGRectMake(imageViewCenter.x - 6.f, imageViewCenter.y - 6.f, 12.f, 12.f);

	CGContextSetFillColorWithColor(context, result.success ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor);
	CGContextFillEllipseInRect(context, imageRect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}



@end
