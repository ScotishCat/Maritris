//
//  EMIArrayModelChanges+EMIIndexPathInitializers.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/28/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMIArrayModelChanges.h"

@class EMIArrayModelChangesOneIndex;
@class EMIArrayModelChangesTwoIndices;

@interface EMIArrayModelChanges (EMIIndexPathInitializers)

+ (EMIArrayModelChangesOneIndex *)addModelWithIndexPath:(NSIndexPath *)indexPath;
+ (EMIArrayModelChangesOneIndex *)removeModelWithIndexPath:(NSIndexPath *)indexPath;
+ (EMIArrayModelChangesTwoIndices *)moveModelFromIndexPath:(NSIndexPath *)fromIndexPath
                                               toIndexPath:(NSIndexPath *)toIndexPath;

@end
