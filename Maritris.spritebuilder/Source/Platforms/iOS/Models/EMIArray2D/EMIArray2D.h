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

+ (instancetype)arrayWithColumnsNumber:(NSUInteger)columnsNumber rowsNumber:(NSUInteger)rowsNumber;

- (instancetype)initWithColumnsNumber:(NSUInteger)columnsNumber rowsNumber:(NSUInteger)rowsNumber;

- (id)objectAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)setObject:(id)object atColumn:(NSUInteger)column row:(NSUInteger)row;

@end
