//
//  EMIShapeSquare.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShapeSquare.h"
#import "EMIBlockPosition.h"

@implementation EMIShapeSquare

- (NSDictionary *)blockOffsetsToOrientationMap {
    /*

    | 0*| 1 |
    | 2 | 3 |

    * marks the anchor point of the shape

    The square shape will not rotate.

    */

    NSArray *offsets = @[[EMIBlockPosition positionWithColumn:0 row:0],
                         [EMIBlockPosition positionWithColumn:1 row:0],
                         [EMIBlockPosition positionWithColumn:0 row:1],
                         [EMIBlockPosition positionWithColumn:1 row:1]];
    
    return @{@(EMIShapeOrientation0) : offsets,
             @(EMIShapeOrientation90) : offsets,
             @(EMIShapeOrientation180) : offsets,
             @(EMIShapeOrientation270) : offsets,
            };
}

- (NSDictionary *)bottomBlocksToOrientationMap {
    NSArray *blocks = self.blocks;
    NSArray *bottomBlocks = @[blocks[kEMIShapeThirdBlockIndex], blocks[kEMIShapeFourthBlockIndex]];

    return @{@(EMIShapeOrientation0) : bottomBlocks,
             @(EMIShapeOrientation90) : bottomBlocks,
             @(EMIShapeOrientation180) : bottomBlocks,
             @(EMIShapeOrientation270) : bottomBlocks,
            };
}

@end
