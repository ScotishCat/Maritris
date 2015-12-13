//
//  EMIGameCenter.h
//  Maritris
//
//  Created by Marina Butovich on 12/12/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EMILoadLeaderboarCompletion)(NSArray *scores);
typedef void(^EMIGameCenterAuthenticateCompletion)(BOOL authenticated, NSError *error);

@interface EMIGameCenter : NSObject

@property (nonatomic, readonly) BOOL isEnabled;

+ (instancetype)sharedCenter;

- (void)authenticateLocalPlayerWithCompletion:(EMIGameCenterAuthenticateCompletion)completion;

- (void)submitScore:(NSUInteger)score;

- (void)loadLeaderboardWithCompletion:(EMILoadLeaderboarCompletion)completion;

@end
