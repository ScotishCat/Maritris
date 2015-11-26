//
//  EMIShape+RandomCreation.h
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIShape.h"

@interface EMIShape (RandomCreation)

+ (EMIShape *)randomShapeWithPosition:(EMIBlockPosition *)position;

@end
