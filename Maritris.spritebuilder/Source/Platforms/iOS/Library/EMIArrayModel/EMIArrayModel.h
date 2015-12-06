//
//  EMIUsers.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/21/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMIModel.h"

@interface EMIArrayModel : EMIModel  <NSFastEnumeration, NSCoding>
@property (nonatomic, readonly) NSUInteger          count;

- (id)modelAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfModel:(id)model;

- (BOOL)containsModel:(id)model;

- (void)addModel:(id)model;
- (void)insertModel:(id)model atIndex:(NSUInteger)index;

- (void)removeModel:(id)model;
- (void)removeModelAtIndex:(NSUInteger)index;

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (void)setObject:(id)model atIndexedSubscript:(NSUInteger)index;
- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end
