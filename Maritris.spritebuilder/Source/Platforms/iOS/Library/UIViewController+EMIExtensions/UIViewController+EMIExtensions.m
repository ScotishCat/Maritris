//
//  UIViewController+EMIExtensions.m
//  EMISquareHolder
//
//  Created by Marina Butovich on 9/15/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "UIViewController+EMIExtensions.h"

@implementation UIViewController (EMIExtensions)

+ (instancetype)controller {
    return [[self alloc] initWithNibName:[self nibName] bundle:nil];
}

+ (NSString *)nibName {
    return nil;
}

@end
