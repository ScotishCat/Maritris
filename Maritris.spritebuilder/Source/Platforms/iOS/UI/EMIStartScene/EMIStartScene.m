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

#import "UIViewController+EMIExtensions.h"

static NSString * const kEMIBackgroundMusicName     = @"Pixelland";
static NSString * const kEMIBackgroundMusicFileType = @"mp3";
static NSString * const kEMIMainSceneTitle          = @"EMIMainScene";

@implementation EMIStartScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:kEMIBackgroundMusicName
                                                              ofType:kEMIBackgroundMusicFileType];
        if (musicPath) {
            [[OALSimpleAudio sharedInstance] playBg:musicPath loop:YES];
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark Interface Handler

- (void)onLeaderboardButton {
    EMILeaderboardViewController *controller = [EMILeaderboardViewController controller];
    [[EMITransitionManager sharedTransitionManager] pushNextViewController:controller];
}

- (void)onPlayButton {
    CCScene *scene = [CCBReader loadAsScene:kEMIMainSceneTitle];
    [[EMITransitionManager sharedTransitionManager] showNextScene:scene];
}

@end
