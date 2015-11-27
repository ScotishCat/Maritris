//
//  EMITransitionManager.h
//  Maritris
//
//  Created by Marina Butovich on 11/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMIStartScene.h"

@interface EMITransitionManager : NSObject <EMIStartSceneDelegate>
@property (nonatomic, strong)   CCNavigationController  *navController;

@end
