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
#import "SpecRunnerStatusImage.h"

@interface SpecRunnerExampleResultCell()
//@property (nonatomic, strong) UIImage *statusImage;
@end


@implementation SpecRunnerExampleResultCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
		self.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
		self.textLabel.adjustsFontSizeToFitWidth = YES;
#ifdef __IPHONE_6_0
		[self.textLabel setMinimumScaleFactor:.8];
#else
		self.textLabel.minimumFontSize = 12.f;
#endif
		
		self.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.showsReorderControl = NO;
    }
    return self;
}

- (void) updateWithResult:(OCExampleResult *)result {
	if(_result != result){
		_result = result;
	}
	self.textLabel.text = _result.example.name;
	self.detailTextLabel.text = [_result.context description];
	SpecRunnerStatus status = result.isRunning ? SpecRunnerStatusRunning : (result.success ? SpecRunnerStatusSuccess : SpecRunnerStatusFailure);
	UIImage *statusImage = [SpecRunnerStatusImage statusImageForStatus:status inRect:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
	self.imageView.image = statusImage;
}

@end
