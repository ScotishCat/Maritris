//
//  EMIUsers.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/21/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIArrayModel.h"

#import "EMIArrayModelChanges.h"
#import "EMIArrayModelChangesOneIndex.h"
#import "EMIArrayModelChangesTwoIndices.h"

#import "EMIArrayModelChanges+EMIInitializers.h"
#import "NSIndexPath+EMIExtensions.h"
#import "NSMutableArray+EMIExtensions.h"

static  NSString * const kEMIMutableModelsKey    = @"mutableModels";

@interface EMIArrayModel ()
@property (nonatomic, strong)   NSMutableArray  *mutableModels;

- (void)notifyOfChangesWithModel:(id)model;

@end

@implementation EMIArrayModel

@dynamic count;

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableModels = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSUInteger)count {
    return [self.mutableModels count];
}

#pragma mark -
#pragma mark Public

- (id)modelAtIndex:(NSUInteger)index {
    return self.mutableModels[index];
}

- (NSUInteger)indexOfModel:(id)model {
    return [self.mutableModels indexOfObject:model];
}

- (BOOL)containsModel:(id)model {
    return [self.mutableModels containsObject:model];
}

- (void)addModel:(id)model {
    if (![self containsModel:model]) {
        [self insertModel:model atIndex:self.count];
    }
}

- (void)removeModel:(id)model {
    [self removeModelAtIndex:[self.mutableModels indexOfObject:model]];
}

- (void)removeModelAtIndex:(NSUInteger)index {
    [self.mutableModels removeObjectAtIndex:index];
    [self setState:EMIModelDidChange
        withObject:[EMIArrayModelChanges removeModelWithIndex:index]];
}

- (void)insertModel:(id)model atIndex:(NSUInteger)index {
    NSMutableArray *models = self.mutableModels;
    (index == self.count) ? [models addObject:model] : [models insertObject:model atIndex:index];
    [self setState:EMIModelDidChange
        withObject:[EMIArrayModelChanges addModelWithIndex:index]];
}

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    [self.mutableModels moveObjectAtIndex:fromIndex toIndex:toIndex];
    [self setState:EMIModelDidChange
        withObject:[EMIArrayModelChanges moveModelFromIndex:fromIndex
                                                    toIndex:toIndex]];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
    NSMutableArray *models = self.mutableModels;
    assert(index <= models.count);
    
    [models setObject:object atIndexedSubscript:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self.mutableModels objectAtIndexedSubscript:index];
}

#pragma mark -
#pragma mark Private

- (void)notifyOfChangesWithModel:(EMIArrayModel *)model {
    [self notifyOfStateChangedWithSelector:@selector(model:didChange:) withObject:model];
}

#pragma mark -
#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    return [self.mutableModels countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.mutableModels forKey:kEMIMutableModelsKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.mutableModels = [[aDecoder decodeObjectForKey:kEMIMutableModelsKey] mutableCopy];
    }
    
    return self;
}

@end
