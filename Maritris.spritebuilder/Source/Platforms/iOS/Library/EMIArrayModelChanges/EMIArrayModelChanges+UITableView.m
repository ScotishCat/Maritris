//
//  EMIArrayModelChanges+UITableView.m
//  TableView_task_2
//
//  Created by Marina Butovich on 10/7/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChanges+UITableView.h"

#import "EMIArrayModelChangesOneIndex.h"
#import "EMIArrayModelChangesTwoIndices.h"

@implementation EMIArrayModelChanges (UITableView)

- (void)applyToTableView:(UITableView *)tableView {
    [self applyToTableView:tableView rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)applyToTableView:(UITableView *)tableView rowAnimation:(UITableViewRowAnimation)rowAnimation {

}

@end

@implementation EMIArrayModelChangesOneIndex (UITableView)

- (void)applyToTableView:(UITableView *)tableView rowAnimation:(UITableViewRowAnimation)rowAnimation {
    switch (self.state) {
        case EMIArrayModelChangeAdded:
            [tableView insertRowsAtIndexPaths:@[self.indexPath] withRowAnimation:rowAnimation];
            break;
            
        case EMIArrayModelChangeRemoved:
            [tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:rowAnimation];
            break;
            
        default:
            break;
    }
}

@end

@implementation EMIArrayModelChangesTwoIndices (UITableView)

- (void)applyToTableView:(UITableView *)tableView rowAnimation:(UITableViewRowAnimation)rowAnimation {
    [tableView moveRowAtIndexPath:self.fromIndexPath toIndexPath:self.toIndexPath];
}

@end
