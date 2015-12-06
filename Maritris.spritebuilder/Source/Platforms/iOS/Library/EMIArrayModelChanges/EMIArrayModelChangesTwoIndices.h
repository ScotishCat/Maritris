//
//  EMIArrayModelChangesTwoIndices.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMIArrayModelChanges.h"

@interface EMIArrayModelChangesTwoIndices : EMIArrayModelChanges
@property (nonatomic, readonly, assign) NSUInteger  fromIndex;
@property (nonatomic, readonly, assign) NSUInteger  toIndex;

+ (instancetype)modelFromIndex:(NSUInteger)fromIndex
                       toIndex:(NSUInteger)toIndex
                         state:(EMIArrayModelChangeType)state;

@end

@interface  EMIArrayModelChangesTwoIndices (EMIIndexPath)
@property (nonatomic, readonly) NSIndexPath *fromIndexPath;
@property (nonatomic, readonly) NSIndexPath *toIndexPath;

+ (instancetype)modelFromIndexPath:(NSIndexPath *)fromIndexPath
                       toIndexPath:(NSIndexPath *)toIndexPath
                             state:(EMIArrayModelChangeType)state;

@end
