//
//  NSMutableArray+EMIExtensions.h
//  Maritris
//
//  Created by Marina Butovich on 11/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (EMIExtensions)

+ (instancetype)null2DArrayWithColumnsNumber:(NSUInteger)columnsNumber rowsNumber:(NSUInteger)rowsNumber;

- (void)moveObjectAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destinationIndex;

@end
