//
//  EMIBlock.h
//  Maritris
//
//  Created by Marina Butovich on 11/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef NS_ENUM(NSUInteger, EMIBlockColor) {
    EMIBlockColorBlue = 0,
    EMIBlockColorTeal,
    EMIBlockColorOrange,
    EMIBlockColorPurple,
    EMIBlockColorYellow,
    EMIBlockColorRed,
    EMIBlockColorCount
};

@interface EMIBlock : NSObject
@property (nonatomic, readonly, assign) EMIBlockColor   color;
@property (nonatomic, readonly, copy)   NSString        *spriteName;
@property (nonatomic, strong)           id              sprite;
@property (nonatomic, assign)           NSInteger      row;
@property (nonatomic, assign)           NSInteger      column;

- (instancetype)initWithColumn:(NSUInteger)column row:(NSUInteger)row color:(EMIBlockColor)color;

@end
