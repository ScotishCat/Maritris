//
//  EMIMaritrisViewModel.h
//  Maritris
//
//  Created by Marina Butovich on 05/12/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMIMainScene;

@interface EMIMaritrisViewModel : NSObject
@property (nonatomic, readonly, weak) EMIMainScene *scene;

- (instancetype)initWithScene:(EMIMainScene *)scene;

- (void)performGameUpdate;

@end
