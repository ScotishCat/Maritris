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

static NSString *const kEMIBackgroundMusicName = @"Pixelland";
static NSString *const kEMIBackgroundMusicFileType = @"mp3";

@implementation EMIStartScene

#pragma mark -
#pragma mark Interface Handler

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:kEMIBackgroundMusicName ofType:kEMIBackgroundMusicFileType];
        if (musicPath) {
            [[OALSimpleAudio sharedInstance] playBg:musicPath loop:YES];
        }
    }
    
    return self;
}

- (void)onLeaderboardButton {

    EMILeaderboardViewController *contrller = [[EMILeaderboardViewController alloc] initWithNibName:@"EMILeaderboardViewController" bundle:nil];
    [[EMITransitionManager sharedTransitionManager] pushNextViewController:contrller];
}

- (void)onPlayButton {
    CCScene *scene = [CCBReader loadAsScene:@"EMIMainScene"];
    [[EMITransitionManager sharedTransitionManager] showNextScene:scene];
}

@end
