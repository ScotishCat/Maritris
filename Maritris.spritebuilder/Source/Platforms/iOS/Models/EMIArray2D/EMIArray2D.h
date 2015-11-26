//
//  EMIArray2D.h
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMIArray2D : NSObject
@property (nonatomic, readonly) NSUInteger  rowsNumber;
@property (nonatomic, readonly) NSUInteger  columnsNumber;

+ (instancetype)arrayWithRowsNumber:(NSUInteger)rowsNumber columnsNumber:(NSUInteger)columnsNumber;

- (instancetype)initWithRowsNumber:(NSUInteger)rowsNumber columnsNumber:(NSUInteger)columnsNumber;

- (id)objectAtRow:(NSUInteger)row column:(NSUInteger)column;
- (void)setObject:(id)object atRow:(NSUInteger)row column:(NSUInteger)column;

@end
