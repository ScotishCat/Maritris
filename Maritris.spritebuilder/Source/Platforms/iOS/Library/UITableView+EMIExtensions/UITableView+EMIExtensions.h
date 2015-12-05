//
//  UITableView+EMIExtensions.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/21/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMIArrayModelChanges.h"

@interface UITableView (EMIExtensions)

- (id)reusableCellWithClass:(Class)cls;
- (void)updateWithChanges:(id)changes;
- (void)updateWithChanges:(id)changes rowAnimation:(UITableViewRowAnimation)rowAnimation;

@end
