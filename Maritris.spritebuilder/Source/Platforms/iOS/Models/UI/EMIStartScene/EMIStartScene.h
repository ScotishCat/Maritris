//
//  EMIStartScene.h
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class EMIStartScene;

@protocol EMIStartSceneDelegate <NSObject>
@optional

- (void)startSceneDidRequestLeaderboard:(EMIStartScene *)startScene;
- (void)startSceneDidRequestPlayScene:(EMIStartScene *)startScene;

@end

@interface EMIStartScene : CCNode
@property (nonatomic, weak) id<EMIStartSceneDelegate> delegate;

@end