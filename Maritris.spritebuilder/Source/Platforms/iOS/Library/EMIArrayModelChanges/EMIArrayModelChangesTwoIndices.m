//
//  EMIArrayModelChangesTwoIndices.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChangesTwoIndices.h"

#import "NSIndexPath+EMIExtensions.h"

@interface EMIArrayModelChangesTwoIndices ()
@property (nonatomic, assign) NSUInteger  fromIndex;
@property (nonatomic, assign) NSUInteger  toIndex;

@end

@implementation EMIArrayModelChangesTwoIndices

#pragma mark -
#pragma mark Class Methods

+ (instancetype)modelFromIndex:(NSUInteger)fromIndex
                       toIndex:(NSUInteger)toIndex
                         state:(EMIArrayModelChangeType)state
{
    EMIArrayModelChangesTwoIndices *result = [self modelWithState:state];
    result.fromIndex = fromIndex;
    result.toIndex = toIndex;
    
    return result;
}

@end

@implementation EMIArrayModelChangesTwoIndices (EMIIndexPath)

@dynamic fromIndexPath;
@dynamic toIndexPath;

#pragma mark -
#pragma mark Class Methods

+ (instancetype)modelFromIndexPath:(NSIndexPath *)fromIndexPath
                       toIndexPath:(NSIndexPath *)toIndexPath
                         state:(EMIArrayModelChangeType)state
{
    return [self modelFromIndex:fromIndexPath.row toIndex:toIndexPath.row state:state];
}

#pragma mark -
#pragma mark Accessors

- (NSIndexPath *)fromIndexPath {
    return [NSIndexPath indexPathForRow:self.fromIndex];
}

- (NSIndexPath *)toIndexPath {
    return [NSIndexPath indexPathForRow:self.toIndex];
}

@end
