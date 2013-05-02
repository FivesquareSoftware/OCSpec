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


- (id) initWithStyle:(UITableViewCellStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier {
	self = [super initWithStyle:aStyle reuseIdentifier:aReuseIdentifier];
	if (self != nil) {

		_keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kSpecRunnerLabelValueCellLabelWidth, kSpecRunnerLabelValueCellLabelHeight)];
		_keyLabel.backgroundColor = [UIColor clearColor];
		_keyLabel.font = [UIFont boldSystemFontOfSize:12.0];
		_keyLabel.textAlignment = NSTextAlignmentRight;
		_keyLabel.textColor = [UIColor colorWithRed:(107.0/255.0) green:(127.0/255.0) blue:(155.0/255.0) alpha:1.0]; 
		_keyLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin; 
		[self.contentView addSubview:_keyLabel];
		
		
		CGRect valueLabelFrame = CGRectMake(kSpecRunnerLabelValueCellLabelWidth + kSpecRunnerLabelValueCellLabelHorizontalPadding
											, 0.f
											, self.frame.size.width - (kSpecRunnerLabelValueCellLabelWidth + (kSpecRunnerLabelValueCellLabelHorizontalPadding * 3.0))
											, kSpecRunnerLabelValueCellLabelHeight);
		
		_valueLabel = [[UILabel alloc] initWithFrame:valueLabelFrame];
		_valueLabel.backgroundColor = [UIColor clearColor];
		_valueLabel.font = [UIFont boldSystemFontOfSize:12.0];
		_valueLabel.textColor = [UIColor blackColor];
		_valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_valueLabel.numberOfLines = 0;
		[self.contentView addSubview:_valueLabel];
		
	}
	return self;
}


- (CGSize) sizeThatFits:(CGSize)size {
	CGSize fitSize = [super sizeThatFits:size];
	
	CGSize maxValueSize = CGSizeMake(_valueLabel.frame.size.width, 1000.f);
	CGSize valueSize = [_valueLabel.text sizeWithFont:_valueLabel.font constrainedToSize:maxValueSize lineBreakMode:_valueLabel.lineBreakMode];
	
	CGFloat labelHeight = valueSize.height > kSpecRunnerLabelValueCellLabelHeight ? valueSize.height : kSpecRunnerLabelValueCellLabelHeight;
	
	CGFloat minHeight = labelHeight + (2.f * kSpecRunnerLabelValueCellLabelVerticalPadding);

	if(fitSize.height < minHeight) {
		fitSize.height = minHeight;
	}
	return fitSize;
}



@end
