//
//  EMIArrayModelChangesOneIndex.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMIArrayModelChanges.h"

@interface EMIArrayModelChangesOneIndex : EMIArrayModelChanges
@property (nonatomic, readonly, assign) NSUInteger  index;

+ (instancetype)modelWithIndex:(NSUInteger)index state:(EMIArrayModelChangeType)state;

@end

@interface EMIArrayModelChangesOneIndex (EMIIndexPath)
@property (nonatomic, readonly) NSIndexPath *indexPath;

+ (instancetype)modelWithIndexPath:(NSIndexPath *)indexPath state:(EMIArrayModelChangeType)state;

@end
