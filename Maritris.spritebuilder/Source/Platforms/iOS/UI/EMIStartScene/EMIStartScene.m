//
//  EMIStartScene.m
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIStartScene.h"

#import "EMIMainScene.h"
#import "EMITransitionManager.h"
#import "EMILeaderboardViewController.h"

@implementation EMIStartScene

#pragma mark -
#pragma mark Interface Handler

- (void)onLeaderboardButton {

    EMILeaderboardViewController *contrller = [[EMILeaderboardViewController alloc] initWithNibName:@"EMILeaderboardViewController" bundle:nil];
    [[EMITransitionManager sharedTransitionManager] pushNextViewController:contrller];
}

- (void)onPlayButton {
    CCScene *scene = [CCBReader loadAsScene:@"EMIMainScene"];
    [[EMITransitionManager sharedTransitionManager] showNextScene:scene];
}

@end
