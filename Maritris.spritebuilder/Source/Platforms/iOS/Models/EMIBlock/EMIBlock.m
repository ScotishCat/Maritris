//
//  EMIBlock.m
//  Maritris
//
//  Created by Marina Butovich on 11/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIBlock.h"

@interface EMIBlock ()
@property (nonatomic, assign)   EMIBlockColor   color;
@property (nonatomic, copy)     NSString        *spriteName;

@end

@implementation EMIBlock

- (instancetype)initWithColumn:(NSUInteger)column row:(NSUInteger)row color:(EMIBlockColor)color {
    self = [super init];
    if (self) {
        self.color = color;
        self.column = column;
        self.row = row;
    }
    
    return self;
}

@end
