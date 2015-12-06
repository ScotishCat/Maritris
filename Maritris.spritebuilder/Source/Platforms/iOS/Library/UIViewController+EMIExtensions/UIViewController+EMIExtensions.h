//
//  UIViewController+EMIExtensions.h
//  EMISquareHolder
//
//  Created by Marina Butovich on 9/15/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (EMIExtensions)

+ (instancetype)controller;

//  Method to be overridden in subclasses to implement custom search of NIB's name.
//  In case, nil is return value nib file's name is searched according to Apple guides.
+ (NSString *)nibName;

@end
