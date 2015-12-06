//
//  UINib+EMIExtensions.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/20/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINib (EMIExtensions)

+ (UINib *)nibWithClass:(Class)cls;
+ (UINib *)nibWithClass:(Class)cls bundle:(NSBundle *)bundle;

+ (id)objectWithClass:(Class)cls;
+ (id)objectWithClass:(Class)cls owner:(id)owner;
+ (id)objectWithClass:(Class)cls owner:(id)owner bundle:(NSBundle *)bundle;

- (id)objectWithClass:(Class)cls;
- (id)objectWithClass:(Class)cls owner:(id)owner;

@end
