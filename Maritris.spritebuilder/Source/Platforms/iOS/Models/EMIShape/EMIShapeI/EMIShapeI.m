//
//  EMIShapeI.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShapeI.h"
#import "EMIBlockPosition.h"

@implementation EMIShapeI

- (NSDictionary *)blockOffsetsToOrientationMap {
/*
    Orientations 0 and 180:

        | 0*|
        | 1 |
        | 2 |
        | 3 |

    Orientations 90 and 270:

    | 0 | 1*| 2 | 3 |

    * marks the anchor point for the shape

    Anchor point is on the second block in horizontal orientations and on the first block in vertical ones

*/

    NSArray *verticalOffsets = @[[EMIBlockPosition positionWithColumn:0 row:0],
                                 [EMIBlockPosition positionWithColumn:0 row:1],
                                 [EMIBlockPosition positionWithColumn:0 row:2],
                                 [EMIBlockPosition positionWithColumn:0 row:3]];

    NSArray *horizontalOffsets = @[[EMIBlockPosition positionWithColumn:-1 row:0],
                                   [EMIBlockPosition positionWithColumn:0 row:0],
                                   [EMIBlockPosition positionWithColumn:1 row:0],
                                   [EMIBlockPosition positionWithColumn:2 row:0]];
    
    return @{@(EMIShapeOrientation0) : verticalOffsets,
             @(EMIShapeOrientation180) : verticalOffsets,
             @(EMIShapeOrientation90) : horizontalOffsets,
             @(EMIShapeOrientation270) : horizontalOffsets,
            };
}

- (NSDictionary *)bottomBlocksToOrientationMap {
    NSArray *blocks = self.blocks;
    
    NSArray *bottomBlocksHorizontal = blocks;
    NSArray *bottomBlocksVertical = @[blocks[kEMIShapeFourthBlockIndex]];

    return @{@(EMIShapeOrientation0) : bottomBlocksHorizontal,
             @(EMIShapeOrientation90) : bottomBlocksVertical,
             @(EMIShapeOrientation180) : bottomBlocksHorizontal,
             @(EMIShapeOrientation270) : bottomBlocksVertical,
            };
}

@end
