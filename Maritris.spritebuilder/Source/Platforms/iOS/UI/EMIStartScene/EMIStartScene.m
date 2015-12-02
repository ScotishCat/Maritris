//
//  EMIStartScene.m
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIStartScene.h"

@implementation EMIStartScene

#pragma mark -
#pragma mark Interface Handler

- (void)onLeaderboardButton {
    if ([self.delegate respondsToSelector:@selector(startSceneDidRequestLeaderboard:)]) {
        [self.delegate startSceneDidRequestLeaderboard:self];
    }
}

- (void)onPlayButton {
    if ([self.delegate respondsToSelector:@selector(startSceneDidRequestPlayScene:)]) {
        [self.delegate startSceneDidRequestPlayScene:self];
    }
}

@end
