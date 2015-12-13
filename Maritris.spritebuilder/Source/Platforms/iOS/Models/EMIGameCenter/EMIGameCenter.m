//
//  EMIGameCenter.m
//  Maritris
//
//  Created by Marina Butovich on 12/12/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "EMIGameCenter.h"

#import <GameKit/GameKit.h>

static NSString *const kEMILeaderboardID = @"46";

@interface EMIGameCenter ()
@end

@implementation EMIGameCenter

+ (instancetype)sharedCenter {
    static EMIGameCenter *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[self alloc] init];
    });
    
    return __instance;
}

- (BOOL)isEnabled {
    return [GKLocalPlayer localPlayer].isAuthenticated;
}

- (void)authenticateLocalPlayerWithCompletion:(EMIGameCenterAuthenticateCompletion)completion {
    if (self.isEnabled && nil != completion) {
        completion(YES, nil);
        return;
    }
    
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [controller presentViewController:viewController animated:YES completion:nil];
            NSLog(@"Should present view controller: %@", viewController);
        } else {
            NSLog(@"Authentication to GameCenter finished, success: %@, error: %@", (self.isEnabled ? @"YES" : @"NO"), error);
            if (completion) {
                completion(self.isEnabled, error);
            }
        }
    };
}

- (void)submitScore:(NSUInteger)value {
    if (!self.isEnabled) {
        return;
    }
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:kEMILeaderboardID];
    score.value = value;

    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    }];
}


- (void)loadLeaderboardWithCompletion:(EMILoadLeaderboarCompletion)completion {
    if (nil == completion || !self.isEnabled) {
        // We won't be able to return results, so just quit
        return;
    }

    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest) {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.identifier = kEMILeaderboardID;
//        leaderboardRequest.range = NSMakeRange(1,10);
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            if (error != nil) {
                // Handle the error.
                NSLog(@"ERROR: Failed to get the leaderboard for ID: %@, error: %@", kEMILeaderboardID, error);
            }
            if (scores != nil) {
                completion(scores);
            }
        }];
    }
}


@end
