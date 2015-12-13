//
//  EMIGameOverScene.m
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIGameOverScene.h"
#import "EMIGameCenter.h"
#import "EMILeaderboardViewController.h"
#import "UIViewController+EMIExtensions.h"
#import "EMITransitionManager.h"

@implementation EMIGameOverScene

- (void)onLeaderboardButton {
    [[EMIGameCenter sharedCenter] authenticateLocalPlayerWithCompletion:^(BOOL authenticated, NSError *error) {
        if (authenticated) {
            EMILeaderboardViewController *controller = [EMILeaderboardViewController controller];
            [[EMITransitionManager sharedTransitionManager] pushNextViewController:controller];
        }
    }];
}

- (void)onRestartButton {
    if (self.restartButtonTappedHandler) {
        self.restartButtonTappedHandler();
    }
}

@end
