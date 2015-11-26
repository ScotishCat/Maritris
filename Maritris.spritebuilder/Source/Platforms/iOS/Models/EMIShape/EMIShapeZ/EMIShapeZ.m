//
//  EMIShapeZ.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShapeZ.h"
#import "EMIBlockPosition.h"

@implementation EMIShapeZ

- (NSDictionary *)blockOffsetsToOrientationMap {
/*
 
    Orientation 0
    
      * | 0 |
    | 2 | 1 |
    | 3 |
    
    Orientation 90
    
    | 0 | 1*|
        | 2 | 3 |
    
    Orientation 180
    
      * | 0 |
    | 2 | 1 |
    | 3 |
    
    Orientation 270
    
    | 0 | 1*|
        | 2 | 3 |

    * marks the anchor point for the shape

*/

    NSArray *verticalOffsets = @[[EMIBlockPosition positionWithColumn:1 row:0],
                                 [EMIBlockPosition positionWithColumn:1 row:1],
                                 [EMIBlockPosition positionWithColumn:0 row:1],
                                 [EMIBlockPosition positionWithColumn:0 row:2]];
    
    NSArray *horizontalOffsets = @[[EMIBlockPosition positionWithColumn:-1 row:0],
                                   [EMIBlockPosition positionWithColumn:0 row:0],
                                   [EMIBlockPosition positionWithColumn:0 row:1],
                                   [EMIBlockPosition positionWithColumn:1 row:1]];

    return @{@(EMIShapeOrientation0) : verticalOffsets,
             @(EMIShapeOrientation90) : horizontalOffsets,
             @(EMIShapeOrientation180) : verticalOffsets,
             @(EMIShapeOrientation270) : horizontalOffsets};
}

- (NSDictionary *)bottomBlocksToOrientationMap {
    NSArray *blocks = self.blocks;
    
    NSArray *verticalBlocks = @[blocks[kEMIShapeSecondBlockIndex], blocks[kEMIShapeFourthBlockIndex]];
    NSArray *horizontalBlocks = @[blocks[kEMIShapeFirstBlockIndex], blocks[kEMIShapeThirdBlockIndex], blocks[kEMIShapeFourthBlockIndex]];
    
    return @{@(EMIShapeOrientation0) : verticalBlocks,
             @(EMIShapeOrientation90) : horizontalBlocks,
             @(EMIShapeOrientation180) : verticalBlocks,
             @(EMIShapeOrientation270) : horizontalBlocks
            };
}

@end
