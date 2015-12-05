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
#pragma mark Class Methods

+ (id)sharedTransitionManager {
    static EMITransitionManager *__transitionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __transitionManager = [[EMITransitionManager alloc] init];
    });
    
    return __transitionManager;
}

- (void)showNextScene:(CCScene *)scene {
    [[CCDirector sharedDirector] pushScene:scene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)showPreviousScene {
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)showRootScene {
    [[CCDirector sharedDirector] popToRootSceneWithTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)pushNextViewController:(UIViewController *)controller {
    [self.navController pushViewController:controller animated:YES];
}

@end
