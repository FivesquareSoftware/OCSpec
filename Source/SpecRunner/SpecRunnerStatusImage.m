//
//  SpecRunnerStatusImage.m
//  OCSpec
//
//  Created by John Clayton on 8/7/13.
//
//

#import "SpecRunnerStatusImage.h"



@implementation SpecRunnerStatusImage


+ (NSMutableDictionary *) statusImagesByColor {
	static NSMutableDictionary *__statusImagesByColor = nil;
	static dispatch_once_t statusImagesByColorOnceToken;
	dispatch_once(&statusImagesByColorOnceToken, ^{
		__statusImagesByColor = [NSMutableDictionary new];
	});
	return __statusImagesByColor;
}

+ (NSMutableDictionary *) statusImagesForColor:(UIColor *)color {
	NSMutableDictionary *imagesByColor = [self statusImagesByColor];
	NSMutableDictionary *imagesForColor = imagesByColor[color];
	if (nil == imagesForColor) {
		imagesForColor = [NSMutableDictionary new];
		imagesByColor[color] = imagesForColor;
	}
	return imagesForColor;
}

+ (UIImage *)statusImageForStatus:(SpecRunnerStatus)status inRect:(CGRect)rect {
	return [self statusImageForColor:[self statusColorForStatus:status] inRect:rect];
}

+ (UIColor *) statusColorForStatus:(SpecRunnerStatus)status {
	UIColor *color = nil;
	switch (status) {
		case SpecRunnerStatusRunning:
			color = [UIColor orangeColor];
			break;
		case SpecRunnerStatusSuccess:
			color = [UIColor greenColor];
			break;
		case SpecRunnerStatusFailure:
			color = [UIColor redColor];
			break;
			
		default:
			break;
	}
	return color;
}

+ (UIImage *) statusImageForColor:(UIColor *)color inRect:(CGRect)rect {
   	NSValue *rectValue = [NSValue valueWithCGRect:rect];
	NSMutableDictionary *statusImages = [self statusImagesForColor:color];
	UIImage *statusImageForRect = statusImages[rectValue];
	if (nil == statusImageForRect) {
		statusImageForRect = [self generateStatusImageForColor:color inRect:rect];
		statusImages[rectValue] = statusImageForRect;
	}
	return statusImageForRect;
}							   
							   
+ (UIImage *) generateStatusImageForColor:(UIColor *)color inRect:(CGRect)rect {
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
//	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//	CGContextFillRect(context, rect);

	CGPoint rectCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGFloat halfDotDimension = kSpecRunnerStatusImageDimension/2.f;
	CGRect imageRect = CGRectMake(rectCenter.x - halfDotDimension, rectCenter.y - halfDotDimension, kSpecRunnerStatusImageDimension, kSpecRunnerStatusImageDimension);

	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextFillEllipseInRect(context, imageRect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}




@end
