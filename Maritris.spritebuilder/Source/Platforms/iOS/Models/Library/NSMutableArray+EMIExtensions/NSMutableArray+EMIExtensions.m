//
//  NSMutableArray+EMIExtensions.m
//  Maritris
//
//  Created by Marina Butovich on 11/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "NSMutableArray+EMIExtensions.h"

@implementation NSMutableArray (EMIExtensions)

+ (instancetype)null2DArrayWithColumnsNumber:(NSUInteger)columnsNumber rowsNumber:(NSUInteger)rowsNumber {
    NSMutableArray *columns = [[self alloc] initWithCapacity:columnsNumber];
    for (NSUInteger columnsIterator = 0; columnsIterator < columnsNumber; columnsIterator++) {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:rowsNumber];
        
        for (NSUInteger rowsIterator = 0; rowsIterator < rowsNumber; rowsIterator++) {
            [row setObject:[NSNull null] atIndexedSubscript:rowsIterator];
        }
        
        [columns addObject:row];
    }
    
    return columns;
}

@end
