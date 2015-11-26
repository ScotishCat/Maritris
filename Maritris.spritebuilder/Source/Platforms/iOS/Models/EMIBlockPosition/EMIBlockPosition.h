//
//  EMIBlockPosition.h
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

// Describes the position of the block (column, row) of a block on the grid
@interface EMIBlockPosition : NSObject <NSCopying>
@property (nonatomic, readonly, assign) NSUInteger column;
@property (nonatomic, readonly, assign) NSUInteger row;

+ (instancetype)positionWithColumn:(NSUInteger)column row:(NSUInteger)row;

- (instancetype)initWithColumn:(NSUInteger)column row:(NSUInteger)row;

@end
