//
//  NSIndexPath+EMIExtensions.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSIndexPath+EMIExtensions.h"

static const NSUInteger kEMISectionNumber = 0;

@implementation NSIndexPath (EMIExtensions)

+ (instancetype)indexPathForRow:(NSUInteger)row {
    return [self indexPathForRow:row inSection:kEMISectionNumber];
}

@end
