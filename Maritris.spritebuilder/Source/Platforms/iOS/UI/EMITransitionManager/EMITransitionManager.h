//
//  EMITransitionManager.h
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMITransitionManager : NSObject
@property (nonatomic, strong)   CCNavigationController  *navController;

+ (instancetype)sharedTransitionManager;

// The new scene will be executed, the previous scene remains in memory.
// ONLY call it if there is already a running scene.
- (void)showNextScene:(CCScene *)scene;

// Replaces the running scene, with the last scene pushed to the stack
- (void)showPreviousScene;

// Pops out all scenes from the queue until the root scene in the queue
- (void)showRootScene;

// the new ViewController will be executed
- (void)pushNextViewController:(UIViewController *)controller;

@end
