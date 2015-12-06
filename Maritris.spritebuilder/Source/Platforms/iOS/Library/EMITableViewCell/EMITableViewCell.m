//
//  EMITableViewCell.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/20/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMITableViewCell.h"

@implementation EMITableViewCell

#pragma mark -
#pragma mark Accessors

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
