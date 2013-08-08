//
//  SpecRunnerStatusImage.h
//  OCSpec
//
//  Created by John Clayton on 8/7/13.
//
//

#import <UIKit/UIKit.h>

#define kSpecRunnerStatusImageDimension 12.f

typedef NS_ENUM(NSUInteger, SpecRunnerStatus) {
	SpecRunnerStatusRunning = 0,
	SpecRunnerStatusSuccess = 1,
	SpecRunnerStatusFailure = 2
};

@interface SpecRunnerStatusImage : NSObject

+ (UIImage *)statusImageForStatus:(SpecRunnerStatus)status inRect:(CGRect)rect;

@end
