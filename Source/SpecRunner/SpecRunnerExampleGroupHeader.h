//
//  SpecRunnerExampleGroupHeader.h
//  OCSpec
//
//  Created by John Clayton on 8/7/13.
//
//

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
@interface SpecRunnerExampleGroupHeader : UITableViewHeaderFooterView
#else
@interface SpecRunnerExampleGroupHeader : UIView
@property (nonatomic, weak) UILabel *textLabel;
#endif
@end
