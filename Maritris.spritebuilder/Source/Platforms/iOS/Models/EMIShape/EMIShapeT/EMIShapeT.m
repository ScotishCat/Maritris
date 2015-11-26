//
//  EMIShapeT.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShapeT.h"
#import "EMIBlockPosition.h"

@implementation EMIShapeT

- (NSDictionary *)blockOffsetsToOrientationMap {
/*
    Orientation 0
    
      * | 0 |
    | 1 | 2 | 3 |
    
    Orientation 90
    
      * | 1 |
        | 2 | 0 |
        | 3 |
    
    Orientation 180

      *
    | 1 | 2 | 3 |
        | 0 |
    
    Orientation 270
    
      * | 1 |
    | 0 | 2 |
        | 3 |

    * marks the anchor point for the shape

*/

    return @{@(EMIShapeOrientation0) : @[[EMIBlockPosition positionWithColumn:1 row:0],
                                         [EMIBlockPosition positionWithColumn:0 row:1],
                                         [EMIBlockPosition positionWithColumn:1 row:1],
                                         [EMIBlockPosition positionWithColumn:2 row:1]],
             
             @(EMIShapeOrientation90) : @[[EMIBlockPosition positionWithColumn:2 row:1],
                                          [EMIBlockPosition positionWithColumn:1 row:0],
                                          [EMIBlockPosition positionWithColumn:1 row:1],
                                          [EMIBlockPosition positionWithColumn:1 row:2]],
             
             @(EMIShapeOrientation180) : @[[EMIBlockPosition positionWithColumn:1 row:2],
                                           [EMIBlockPosition positionWithColumn:0 row:1],
                                           [EMIBlockPosition positionWithColumn:1 row:1],
                                           [EMIBlockPosition positionWithColumn:2 row:1]],
             
             @(EMIShapeOrientation270) : @[[EMIBlockPosition positionWithColumn:0 row:1],
                                           [EMIBlockPosition positionWithColumn:1 row:0],
                                           [EMIBlockPosition positionWithColumn:1 row:1],
                                           [EMIBlockPosition positionWithColumn:1 row:2]]};
}

- (NSDictionary *)bottomBlocksToOrientationMap {
    NSArray *blocks = self.blocks;
    
    return @{@(EMIShapeOrientation0) : @[blocks[kEMIShapeSecondBlockIndex],
                                         blocks[kEMIShapeThirdBlockIndex],
                                         blocks[kEMIShapeFourthBlockIndex]],
             
             @(EMIShapeOrientation90) : @[blocks[kEMIShapeFirstBlockIndex],
                                          blocks[kEMIShapeFourthBlockIndex]],
             
             @(EMIShapeOrientation180) : @[blocks[kEMIShapeFirstBlockIndex],
                                           blocks[kEMIShapeSecondBlockIndex],
                                           blocks[kEMIShapeFourthBlockIndex]],
             
             @(EMIShapeOrientation270) : @[blocks[kEMIShapeFirstBlockIndex],
                                           blocks[kEMIShapeFourthBlockIndex]]};
}

@end
