//
//	SpecRunnerExampleResultDetailsCell.m
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


#import "SpecRunnerLabelValueCell.h"


#define kSpecRunnerLabelValueCellLabelHeight 44.0
#define kSpecRunnerLabelValueCellLabelHorizontalPadding 10.0
#define kSpecRunnerLabelValueCellLabelVerticalPadding 5.0
#define kSpecRunnerLabelValueCellLabelWidth 58.0


@implementation SpecRunnerLabelValueCell


@synthesize keyLabel=keyLabel_;
@synthesize valueLabel=valueLabel_;


- (id) initWithStyle:(UITableViewCellStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier {
	self = [super initWithStyle:aStyle reuseIdentifier:aReuseIdentifier];
	if (self != nil) {

		keyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kSpecRunnerLabelValueCellLabelWidth, kSpecRunnerLabelValueCellLabelHeight)];
		keyLabel_.backgroundColor = [UIColor clearColor];
		keyLabel_.font = [UIFont boldSystemFontOfSize:12.0];
		keyLabel_.textAlignment = UITextAlignmentRight;
		keyLabel_.textColor = [UIColor colorWithRed:(107.0/255.0) green:(127.0/255.0) blue:(155.0/255.0) alpha:1.0]; 
		keyLabel_.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin; 
		[self.contentView addSubview:keyLabel_];
		
		
		CGRect valueLabelFrame = CGRectMake(kSpecRunnerLabelValueCellLabelWidth + kSpecRunnerLabelValueCellLabelHorizontalPadding
											, 0.f
											, self.frame.size.width - (kSpecRunnerLabelValueCellLabelWidth + (kSpecRunnerLabelValueCellLabelHorizontalPadding * 3.0))
											, kSpecRunnerLabelValueCellLabelHeight);
		
		valueLabel_ = [[UILabel alloc] initWithFrame:valueLabelFrame];
		valueLabel_.backgroundColor = [UIColor clearColor];
		valueLabel_.font = [UIFont boldSystemFontOfSize:12.0];
		valueLabel_.textColor = [UIColor blackColor];
		valueLabel_.lineBreakMode = UILineBreakModeWordWrap;
		valueLabel_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		valueLabel_.numberOfLines = 0;
		[self.contentView addSubview:valueLabel_];
		
	}
	return self;
}


- (CGSize) sizeThatFits:(CGSize)size {
	CGSize fitSize = [super sizeThatFits:size];
	
	CGSize maxValueSize = CGSizeMake(valueLabel_.frame.size.width, 1000.f);
	CGSize valueSize = [valueLabel_.text sizeWithFont:valueLabel_.font constrainedToSize:maxValueSize lineBreakMode:valueLabel_.lineBreakMode];
	
	CGFloat labelHeight = valueSize.height > kSpecRunnerLabelValueCellLabelHeight ? valueSize.height : kSpecRunnerLabelValueCellLabelHeight;
	
	CGFloat minHeight = labelHeight + (2.f * kSpecRunnerLabelValueCellLabelVerticalPadding);

	if(fitSize.height < minHeight) {
		fitSize.height = minHeight;
	}
	return fitSize;
}



@end
