//
//  EMIArrayModelChanges+UITableView.h
//  TableView_task_2
//
//  Created by Marina Butovich on 10/7/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMIArrayModelChanges.h"

@interface EMIArrayModelChanges (UITableView)

- (void)applyToTableView:(UITableView *)tableView;

// to be overriden in subclassing
- (void)applyToTableView:(UITableView *)tableView rowAnimation:(UITableViewRowAnimation)rowAnimation;

@end
