/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 */

#import "cocos2d.h"

#import "EMIAppDelegate.h"
#import "CCBuilderReader.h"

#import "EMITransitionManager.h"
#import "EMIStartScene.h"

@interface EMIAppController ()
@property (nonatomic, strong)   EMITransitionManager    *transitionManager;

@end

@implementation EMIAppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"];
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // transition manager creation
    self.transitionManager = [EMITransitionManager new];
    self.transitionManager.navController = self.navController;
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    return YES;
}

- (CCScene *)startScene {
    CCScene *scene = [CCBReader loadAsScene:@"EMIStartScene"];
    EMIStartScene *startScene = (EMIStartScene *)[scene.children firstObject];
    
    NSParameterAssert([startScene isKindOfClass:[EMIStartScene class]]);
    
    startScene.delegate = self.transitionManager;
    
    return scene;
}

@end
