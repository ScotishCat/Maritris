//
//  EMIGameOverScene.h
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface EMIGameOverScene : CCNode

@property (nonatomic, assign) NSUInteger score;

- (void)onLeaderboardButton;
- (void)onRestartButton;

@property (nonatomic, copy)             dispatch_block_t    restartButtonTappedHandler;

@property (nonatomic, readonly, strong) CCLabelTTF          *scoreLabel;

@end
