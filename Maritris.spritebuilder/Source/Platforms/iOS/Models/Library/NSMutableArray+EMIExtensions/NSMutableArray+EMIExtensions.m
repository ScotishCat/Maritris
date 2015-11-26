//
//  NSMutableArray+EMIExtensions.m
//  Maritris
//
//  Created by Marina Butovich on 11/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "NSMutableArray+EMIExtensions.h"

@implementation NSMutableArray (EMIExtensions)

+ (instancetype)null2DArrayWithRowsNumber:(NSUInteger)rowsNumber columnsNumber:(NSUInteger)columnsNumber {
    NSMutableArray *rows = [[self alloc] initWithCapacity:rowsNumber];
    for (NSUInteger iterator = 0; iterator < rowsNumber; iterator++) {
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:columnsNumber];
        
        for (NSUInteger iterator = 0; iterator < columnsNumber; iterator++) {
            [column setObject:[NSNull null] atIndexedSubscript:iterator];
        }
        
        [rows addObject:column];
    }
    
    return rows;
}

@end
