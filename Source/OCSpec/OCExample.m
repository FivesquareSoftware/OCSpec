//
//  OCExample.m
//  OCSpec
//
//  Created by John Clayton on 5/1/13.
//
//

#import "OCExample.h"


@implementation OCExample

+ (id) withName:(NSString *)name inGroup:(OCExampleGroup *)group {
	OCExample *example = [self new];
	example.name = name;
	example.group = group;
	return example;
}

- (NSString *) description {
//	return [NSString stringWithFormat:@"%@ %@",[super description],_name];
	return _name;
}

- (NSIndexPath *) indexPath {
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:_group.index];
	indexPath = [indexPath indexPathByAddingIndex:_index];
	return indexPath;
}

@end
