//
//  EMITransitionManager.m
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMITransitionManager.h"

@implementation EMITransitionManager

#pragma mark -
#pragma mark EMIStartSceneDelegate

- (void)startSceneDidRequestLeaderboard:(EMIStartScene *)startScene {
    UIViewController *controller = nil;
    [self.navController pushViewController:controller animated:YES];
}

- (void)startSceneDidRequestPlayScene:(EMIStartScene *)startScene {
    CCScene *scene = [CCBReader loadAsScene:@"EMIMainScene"];
    [[CCDirector sharedDirector] pushScene:scene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
