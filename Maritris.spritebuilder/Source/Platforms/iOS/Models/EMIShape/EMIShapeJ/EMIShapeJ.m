//
//  EMIShapeJ.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShapeJ.h"
#import "EMIBlockPosition.h"

@implementation EMIShapeJ

- (NSDictionary *)blockOffsetsToOrientationMap {
/*
    Orientation 0:

     * | 0 |
       | 1 |
   | 3 | 2 |
 

    Orientation 90:

    | 3*|
    | 2 | 1 | 0 |

    Orientation 180:

    | 2*| 3 |
    | 1 |
    | 0 |

    Orientation 270:

    | 0*| 1 | 2 |
            | 3 |

    * marks the anchor point for the shape

*/

    return @{@(EMIShapeOrientation0) : @[[EMIBlockPosition positionWithColumn:1 row:0],
                                         [EMIBlockPosition positionWithColumn:1 row:1],
                                         [EMIBlockPosition positionWithColumn:1 row:2],
                                         [EMIBlockPosition positionWithColumn:0 row:2]],
             
             @(EMIShapeOrientation90) : @[[EMIBlockPosition positionWithColumn:2 row:1],
                                          [EMIBlockPosition positionWithColumn:1 row:1],
                                          [EMIBlockPosition positionWithColumn:0 row:1],
                                          [EMIBlockPosition positionWithColumn:0 row:0]],
             
             @(EMIShapeOrientation180) : @[[EMIBlockPosition positionWithColumn:0 row:2],
                                           [EMIBlockPosition positionWithColumn:0 row:1],
                                           [EMIBlockPosition positionWithColumn:0 row:0],
                                           [EMIBlockPosition positionWithColumn:1 row:0]],
             
             @(EMIShapeOrientation270) : @[[EMIBlockPosition positionWithColumn:0 row:0],
                                           [EMIBlockPosition positionWithColumn:1 row:0],
                                           [EMIBlockPosition positionWithColumn:2 row:0],
                                           [EMIBlockPosition positionWithColumn:2 row:1]]};
}

- (NSDictionary *)bottomBlocksToOrientationMap {
    NSArray *blocks = self.blocks;
    
    return @{@(EMIShapeOrientation0) : @[blocks[kEMIShapeThirdBlockIndex],
                                         blocks[kEMIShapeFourthBlockIndex]],
             
             @(EMIShapeOrientation90) : @[blocks[kEMIShapeFirstBlockIndex],
                                          blocks[kEMIShapeSecondBlockIndex],
                                          blocks[kEMIShapeThirdBlockIndex]],
             
             @(EMIShapeOrientation180) : @[blocks[kEMIShapeFirstBlockIndex],
                                           blocks[kEMIShapeFourthBlockIndex]],
             
             @(EMIShapeOrientation270) : @[blocks[kEMIShapeFirstBlockIndex],
                                           blocks[kEMIShapeSecondBlockIndex],
                                           blocks[kEMIShapeFourthBlockIndex]]};
}

@end
