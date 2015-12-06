//
//  EMIArrayModelChanges+EMIInitializers.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/28/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModelChanges.h"

@class EMIArrayModelChangesOneIndex;
@class EMIArrayModelChangesTwoIndices;

@interface EMIArrayModelChanges (EMIInitializers)

+ (EMIArrayModelChangesOneIndex *)addModelWithIndex:(NSUInteger)index;
+ (EMIArrayModelChangesOneIndex *)removeModelWithIndex:(NSUInteger)index;
+ (EMIArrayModelChangesTwoIndices *)moveModelFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
