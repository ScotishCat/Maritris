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
@property (nonatomic, strong)   NSMutableArray  *rows;

@end

@implementation EMIArray2D

#pragma mark -
#pragma mark Class Methods

+ (instancetype)arrayWithRowsNumber:(NSUInteger)rowsNumber columnsNumber:(NSUInteger)columnsNumber {
    return [[self alloc] initWithRowsNumber:rowsNumber columnsNumber:columnsNumber];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRowsNumber:(NSUInteger)rowsNumber columnsNumber:(NSUInteger)columnsNumber {
    self = [super init];
    if (self) {
        self.rows = [NSMutableArray null2DArrayWithRowsNumber:rowsNumber columnsNumber:columnsNumber];
        self.rowsNumber = rowsNumber;
        self.columnsNumber = columnsNumber;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public

- (id)objectAtRow:(NSUInteger)row column:(NSUInteger)column {
    return [[self.rows objectAtIndex:row] objectAtIndex:column];
}

- (void)setObject:(id)object atRow:(NSUInteger)row column:(NSUInteger)column {
    [[self.rows objectAtIndex:row] replaceObjectAtIndex:column withObject:object];
}

@end
