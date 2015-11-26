//
//  EMIArray2D.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIArray2D.h"

#import "NSMutableArray+EMIExtensions.h"

@interface EMIArray2D ()
@property (nonatomic, assign)   NSUInteger      rowsNumber;
@property (nonatomic, assign)   NSUInteger      columnsNumber;
@property (nonatomic, strong)   NSMutableArray  *columns;

@end

@implementation EMIArray2D

#pragma mark -
#pragma mark Class Methods

+ (instancetype)arrayWithColumnsNumber:(NSUInteger)columnsNumber rowsNumber:(NSUInteger)rowsNumber {
    return [[self alloc] initWithColumnsNumber:columnsNumber rowsNumber:rowsNumber];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithColumnsNumber:(NSUInteger)columnsNumber rowsNumber:(NSUInteger)rowsNumber {
    self = [super init];
    if (self) {
        self.columns = [NSMutableArray null2DArrayWithColumnsNumber:columnsNumber rowsNumber:rowsNumber];
        self.rowsNumber = rowsNumber;
        self.columnsNumber = columnsNumber;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public

- (id)objectAtColumn:(NSUInteger)column row:(NSUInteger)row {
    return [[self.columns objectAtIndex:column] objectAtIndex:row];
}

- (void)setObject:(id)object atColumn:(NSUInteger)column row:(NSUInteger)row {
    [[self.columns objectAtIndex:column] replaceObjectAtIndex:row withObject:object];
}

@end
