//
//  EMIArrayModelChanges+EMIIndexPathInitializers.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/28/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChanges+EMIIndexPathInitializers.h"

#import "EMIArrayModelChanges+EMIInitializers.h"

@implementation EMIArrayModelChanges (EMIIndexPathInitializers)

#pragma mark -
#pragma mark Class Methods

+ (EMIArrayModelChangesOneIndex *)addModelWithIndexPath:(NSIndexPath *)indexPath {
    return [self addModelWithIndex:indexPath.row];
}

+ (EMIArrayModelChangesOneIndex *)removeModelWithIndexPath:(NSIndexPath *)indexPath {
    return [self removeModelWithIndex:indexPath.row];
}

+ (EMIArrayModelChangesTwoIndices *)moveModelFromIndexPath:(NSIndexPath *)fromIndexPath
                                               toIndexPath:(NSIndexPath *)toIndexPath
{
    return [self moveModelFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

@end

