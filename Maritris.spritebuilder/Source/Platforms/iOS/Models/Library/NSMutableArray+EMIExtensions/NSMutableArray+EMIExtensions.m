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
    for (NSUInteger iterator = 0; iterator < columnsNumber; iterator++) {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:rowsNumber];
        
        for (NSUInteger iterator = 0; iterator < rowsNumber; iterator++) {
            [row setObject:[NSNull null] atIndexedSubscript:iterator];
        }
        
        [columns addObject:row];
    }
    
    return columns;
}

@end
