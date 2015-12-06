//
//  EMIArrayModelChangesOneIndex.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChangesOneIndex.h"

#import "NSIndexPath+EMIExtensions.h"

@interface EMIArrayModelChangesOneIndex ()
@property (nonatomic, assign) NSUInteger  index;

@end

@implementation EMIArrayModelChangesOneIndex

#pragma mark -
#pragma mark Class Methods

+ (instancetype)modelWithIndex:(NSUInteger)index state:(EMIArrayModelChangeType)state {
    EMIArrayModelChangesOneIndex *result = [self modelWithState:state];
    result.index = index;
    
    return result;
}

@end

@implementation EMIArrayModelChangesOneIndex (EMIIndexPath)

@dynamic indexPath;

#pragma mark -
#pragma mark Class Methods

+ (instancetype)modelWithIndexPath:(NSIndexPath *)indexPath state:(EMIArrayModelChangeType)state {
    return [self modelWithIndex:indexPath.row state:state];
}

#pragma mark -
#pragma mark Accessors

- (NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:self.index];
}

@end