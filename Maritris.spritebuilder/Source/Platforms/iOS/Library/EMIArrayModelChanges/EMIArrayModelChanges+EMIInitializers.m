//
//  EMIArrayModelChanges+EMIInitializers.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/28/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChanges+EMIInitializers.h"

#import "EMIArrayModelChangesOneIndex.h"
#import "EMIArrayModelChangesTwoIndices.h"

@implementation EMIArrayModelChanges (EMIInitializers)

#pragma mark -
#pragma mark Class Methods

+ (EMIArrayModelChangesOneIndex *)addModelWithIndex:(NSUInteger)index {
    return [EMIArrayModelChangesOneIndex modelWithIndex:index state:EMIArrayModelChangeAdded];
}

+ (EMIArrayModelChangesOneIndex *)removeModelWithIndex:(NSUInteger)index {
    return [EMIArrayModelChangesOneIndex modelWithIndex:index state:EMIArrayModelChangeRemoved];
}

+ (EMIArrayModelChangesTwoIndices *)moveModelFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    return [EMIArrayModelChangesTwoIndices modelFromIndex:fromIndex
                                                  toIndex:toIndex
                                                    state:EMIArrayModelChangeMoved];
}

@end

