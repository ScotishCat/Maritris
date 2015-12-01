//
//  EMIShape.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShape.h"
#import "EMIBlock.h"
#import "EMIBlockPosition.h"

const NSUInteger kEMIShapeFirstBlockIndex = 0;
const NSUInteger kEMIShapeSecondBlockIndex = 1;
const NSUInteger kEMIShapeThirdBlockIndex = 2;
const NSUInteger kEMIShapeFourthBlockIndex = 3;


@interface EMIShape ()
@property (nonatomic, assign)   EMIBlockColor       color;
@property (nonatomic, assign)   EMIShapeOrientation orientation;
@property (nonatomic, copy)     NSArray             *blocks;

- (void)setUpBlocks;
- (EMIBlockColor)randomColor;
- (EMIShapeOrientation)randomOrientation;

- (void)rotateToOrientation:(EMIShapeOrientation)orientation;

@end

@implementation EMIShape

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithPosition:(EMIBlockPosition *)position
                           color:(EMIBlockColor)color
                     orientation:(EMIShapeOrientation)orientation
{
    self = [super init];
    if (self) {
        self.anchorPosition = position;
        self.color = color;
        self.orientation = orientation;
        [self setUpBlocks];
    }
    
    return self;
}

- (instancetype)initWithPosition:(EMIBlockPosition *)position {
    return [self initWithPosition:position color:[self randomColor] orientation:[self randomOrientation]];
}

#pragma mark -
#pragma mark Public

- (NSArray *)bottomBlocks {
    NSArray *result = self.bottomBlocksToOrientationMap[@(self.orientation)];
    if (!result) {
        return @[];
    }
    return result;
}

- (void)rotateRight {
    EMIShapeOrientation newOrientation = [self rotateOrientation:self.orientation clockwise:YES];
    [self rotateToOrientation:newOrientation];
    self.orientation = newOrientation;
}

- (void)rotateLeft {
    EMIShapeOrientation newOrientation = [self rotateOrientation:self.orientation clockwise:NO];
    [self rotateToOrientation:newOrientation];
    self.orientation = newOrientation;
}

- (void)moveDownOneRow {
    [self moveByColumns:0 rows:1];
}

- (void)moveUpOneRow {
    [self moveByColumns:0 rows:-1];
}

- (void)moveLeftOneColumn {
    [self moveByColumns:-1 rows:0];
}

- (void)moveRightOneColumn {
    [self moveByColumns:1 rows:0];
}

- (void)moveToPosition:(EMIBlockPosition *)position {
    self.anchorPosition = position;
    [self rotateToOrientation:self.orientation];
}

#pragma mark -
#pragma mark For Subclassing

- (NSDictionary *)bottomBlocksToOrientationMap {
    return @{};
}

- (NSDictionary *)blockOffsetsToOrientationMap {
    return @{};
}

#pragma mark -
#pragma mark Private

// Create the blocks array
- (void)setUpBlocks {
    // Block offsets are EMIBlockPosition objects that specify distance between shape's anchorPoint and each block of the shape
    NSArray *blocksOffsets = self.blockOffsetsToOrientationMap[@(self.orientation)];
    if (!blocksOffsets) {
        return;
    }
    
    // Remember the row and column of the anchor position. We will use it to calculate the position of each block based on the shape's anchor's point and relative offset of each block.
    NSUInteger anchorRow = self.anchorPosition.row;
    NSUInteger anchorColumn = self.anchorPosition.column;
    EMIBlockColor currentColor = self.color;
    
    // Create new mutable array and fill it with newly created blocks.
    NSMutableArray *blocks = [NSMutableArray arrayWithCapacity:[blocksOffsets count]];
    for (EMIBlockPosition *currentOffset in blocksOffsets) {
        EMIBlock *newblock = [[EMIBlock alloc] initWithColumn:anchorColumn + currentOffset.column
                                                          row:anchorRow + currentOffset.row
                                                        color:currentColor];
        if (newblock) {
            [blocks addObject:newblock];
        }
    }
    
    // Copy the created array
    self.blocks = blocks;
}

- (EMIBlockColor)randomColor {
    return (EMIBlockColor)arc4random_uniform(EMIBlockColorCount);
}

- (EMIShapeOrientation)randomOrientation {
    return (EMIShapeOrientation)arc4random_uniform(EMIShapeOrientationCount);
}

- (void)rotateToOrientation:(EMIShapeOrientation)orientation {
    NSArray *blocksOffsets = self.blockOffsetsToOrientationMap[@(orientation)];
    if (!blocksOffsets) {
        return;
    }
    
    assert([blocksOffsets count] == [self.blocks count]);
    
    NSUInteger anchorRow = self.anchorPosition.row;
    NSUInteger anchorColumn = self.anchorPosition.column;
    
    // We have to iterate over 2 matching arrays: array of blocks and array of offsets of each block from the anchor point,
    // so use the simple index-based iteration.
    for (NSUInteger index = 0; index < [blocksOffsets count]; index++) {
        EMIBlock *block = self.blocks[index];
        EMIBlockPosition *offset = blocksOffsets[index];
        
        block.column = anchorColumn + offset.column;
        block.row = anchorRow + offset.row;
    }
}

- (EMIShapeOrientation)rotateOrientation:(EMIShapeOrientation)orientation clockwise:(BOOL)clockwise {
    // Increase or decrease orientation value by 1
    NSInteger value = orientation + (clockwise ? 1 : -1);
    EMIShapeOrientation newOrientation = (EMIShapeOrientation)value == EMIShapeOrientationCount ? EMIShapeOrientation0 : value;
    if (value > EMIShapeOrientation270) {
        // We've made 360 degree turn, reset to 0
        newOrientation = EMIShapeOrientation0;
    } else if (value < 0) {
        // We've went past 0 degrees, reset to 270 degrees
        newOrientation = EMIShapeOrientation270;
    }
    
    return newOrientation;
}

- (void)moveByColumns:(NSUInteger)columns rows:(NSUInteger)rows {
    EMIBlockPosition *anchor = self.anchorPosition;
    EMIBlockPosition *newAnchor = [EMIBlockPosition positionWithColumn:anchor.column + columns row:anchor.row + rows];
    self.anchorPosition = newAnchor;
    
    for (EMIBlock *block in self.blocks) {
        block.row += rows;
        block.column += columns;
    }
}

@end
