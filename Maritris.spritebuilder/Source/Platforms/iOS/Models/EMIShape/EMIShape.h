//
//  EMIShape.h
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMIBlock.h"

@class EMIBlockPosition;

// Describes rotation of a shape around its position block
typedef NS_ENUM(NSUInteger, EMIShapeOrientation) {
    EMIShapeOrientation0 = 0,
    EMIShapeOrientation90,
    EMIShapeOrientation180,
    EMIShapeOrientation270,
    EMIShapeOrientationCount
};

// Indexes of 4 blocks, from which shapes are constructed
extern const NSUInteger kEMIShapeFirstBlockIndex;
extern const NSUInteger kEMIShapeSecondBlockIndex;
extern const NSUInteger kEMIShapeThirdBlockIndex;
extern const NSUInteger kEMIShapeFourthBlockIndex;

// Base class for all Tetrominos (figures)
@interface EMIShape : NSObject
// Shape's color (used for all underlying blocks of shape)
@property (nonatomic, readonly, assign) EMIBlockColor       color;
// Orientation of the shape
@property (nonatomic, readonly, assign) EMIShapeOrientation orientation;
// A position of the block, that represents shape's anchor point
@property (nonatomic, copy)             EMIBlockPosition    *anchorPosition;
// Array of blocks that are currently on the bottom (depends on current orientation)
@property (nonatomic, readonly)         NSArray             *bottomBlocks;
// Array of actual blocks of the shape
@property (nonatomic, readonly, copy)   NSArray             *blocks;

- (instancetype)initWithPosition:(EMIBlockPosition *)position
                           color:(EMIBlockColor)color
                     orientation:(EMIShapeOrientation)orientation;

- (instancetype)initWithPosition:(EMIBlockPosition *)position;

- (void)rotateRight;
- (void)rotateLeft;

- (void)moveDownOneRow;
- (void)moveUpOneRow;
- (void)moveLeftOneColumn;
- (void)moveRightOneColumn;
- (void)moveToPosition:(EMIBlockPosition *)position;

// FOR SUBCLASSING

// Returns a dictionary where key is EMIShapeOrientation wrapped in NSNumber, and value is array of bottom blocks
// Must be overridden in subclasses.
- (NSDictionary *)bottomBlocksToOrientationMap;


// Returns a dictionary where keys are EMIShapeOrientation wrapped in NSNumber, and values are arrays of EMIBlockPosition objects, where each position is a distance of each block to the anchor position
- (NSDictionary *)blockOffsetsToOrientationMap;

@end
