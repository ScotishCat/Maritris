//
//  EMIShape+RandomCreation.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShape+RandomCreation.h"

#import "EMIShapeSquare.h"
#import "EMIShapeI.h"
#import "EMIShapeJ.h"
#import "EMIShapeL.h"
#import "EMIShapeS.h"
#import "EMIShapeS.h"
#import "EMIShapeT.h"
#import "EMIShapeZ.h"

static const NSUInteger kEMINumberOfShapeTypes = 7;

@implementation EMIShape (RandomCreation)

+ (EMIShape *)randomShapeWithPosition:(EMIBlockPosition *)position {
    EMIShape *result = nil;
    
    switch (arc4random_uniform(kEMINumberOfShapeTypes)) {
      case 0:
        result = [[EMIShapeI alloc] initWithPosition:position];
        break;

      case 1:
        result = [[EMIShapeJ alloc] initWithPosition:position];
        break;

      case 2:
        result = [[EMIShapeT alloc] initWithPosition:position];
        break;

      case 3:
        result = [[EMIShapeS alloc] initWithPosition:position];
        break;

      case 4:
        result = [[EMIShapeZ alloc] initWithPosition:position];
        break;

      case 5:
        result = [[EMIShapeL alloc] initWithPosition:position];
        break;

      case 6:
      default:
        result = [[EMIShapeSquare alloc] initWithPosition:position];
        break;
    }
    
    return result;
}

@end
