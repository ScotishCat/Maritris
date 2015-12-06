//
//  EMIArrayModelChanges.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChanges.h"

#import "EMIArrayModelChangesOneIndex.h"
#import "EMIArrayModelChangesTwoIndices.h"

@interface EMIArrayModelChanges ()
@property (nonatomic, assign)   EMIArrayModelChangeType state;

@end

@implementation EMIArrayModelChanges

#pragma mark -
#pragma mark Class Methods

+ (instancetype)modelWithState:(EMIArrayModelChangeType)state {
    EMIArrayModelChanges *result = [self new];
    result.state = state;
    
    return result;
}

@end
