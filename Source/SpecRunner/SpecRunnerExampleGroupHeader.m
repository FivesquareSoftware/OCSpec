//
//  SpecRunnerExampleGroupHeader.m
//  OCSpec
//
//  Created by John Clayton on 8/7/13.
//
//

#import "SpecRunnerExampleGroupHeader.h"

@interface SpecRunnerExampleGroupHeader ()
@end

@implementation SpecRunnerExampleGroupHeader

- (void) initialize {
//	self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) ready {
	self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
	self.backgroundColor = [UIColor blackColor];
	self.alpha = 0.5;

	CGRect labelRect = CGRectInset(self.bounds, 12.f, 0);
	UILabel *textLabel = [[UILabel alloc] initWithFrame:labelRect];
	textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	textLabel.opaque = NO;
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.font = [UIFont boldSystemFontOfSize:14.0];
	textLabel.textAlignment = NSTextAlignmentLeft;
	textLabel.textColor = [UIColor whiteColor];
	[self addSubview:textLabel];

	_textLabel = textLabel;
#else
	self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
	self.textLabel.textColor = [UIColor whiteColor];
#endif
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
		[self ready];
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self) {
        [self initialize];
		[self ready];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self ready];
}

@end
