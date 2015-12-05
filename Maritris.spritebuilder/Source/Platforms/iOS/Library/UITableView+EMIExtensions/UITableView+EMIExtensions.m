//
//  UITableView+EMIExtensions.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/21/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "UITableView+EMIExtensions.h"

#import "UINib+EMIExtensions.h"
#import "EMIArrayModelChanges+UITableView.h"

@implementation UITableView (EMIExtensions)

- (id)reusableCellWithClass:(Class)cls {
    id cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cls)];
    if (!cell) {
        cell = [UINib objectWithClass:cls];
    }
    
    return cell;
}

- (void)updateWithChanges:(id)changes {
    [self updateWithChanges:changes rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateWithChanges:(id)changes rowAnimation:(UITableViewRowAnimation)rowAnimation {
    UITableView *tableView = self;
    [tableView beginUpdates];
    
    [changes applyToTableView:tableView rowAnimation:rowAnimation];
    
    [tableView endUpdates];
}

@end
