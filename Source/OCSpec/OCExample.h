//
//  OCExample.h
//  OCSpec
//
//  Created by John Clayton on 5/1/13.
//
//

#import <Foundation/Foundation.h>

#import "OCExampleGroup.h"

@interface OCExample : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) OCExampleGroup *group;
@property (nonatomic) NSUInteger index;
@property (nonatomic, readonly) NSIndexPath *indexPath;

+ (id) withName:(NSString *)name inGroup:(OCExampleGroup *)group;

@end
