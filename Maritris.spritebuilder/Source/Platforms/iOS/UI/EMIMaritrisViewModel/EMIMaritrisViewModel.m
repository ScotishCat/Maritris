//
//  EMIMaritrisViewModel.m
//  Maritris
//
//  Created by Marina Butovich on 05/12/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "EMIMaritrisViewModel.h"

#import "EMIMaritrisGame.h"
#import "EMIMainScene.h"
#import "EMIShape.h"
#import "EMIBlock.h"
#import "EMIMacros.h"

static const NSTimeInterval kEMIUpdateIntervalMillisecondsLevelOne  = 600.0f;

@interface EMIMaritrisViewModel () <EMIMaritrisGameDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak)                         EMIMainScene    *scene;
@property (nonatomic, strong)                       EMIMaritrisGame *gameLogic;
@property (nonatomic, strong)                       UIView          *view;

@property (nonatomic, assign)                       CGPoint         lastPanLocation;
@property (nonatomic, assign, getter=isDraggingInProgress)  BOOL     draggingInProgress;
@property (nonatomic, assign, getter=isUpdating)            BOOL    updating;

- (void)performGameUpdate;

@end

@implementation EMIMaritrisViewModel

- (instancetype)initWithScene:(EMIMainScene *)scene {
    self = [super init];
    if (self) {
        self.scene = scene;
        
        self.gameLogic = [EMIMaritrisGame new];
        self.gameLogic.delegate = self;

        [self setUpView];
        
        [self.gameLogic startGame];
    }
    
    return self;
}

- (void)performGameUpdate {
    [self.gameLogic moveShapeDown];
}

#pragma mark -
#pragma mark EMIMaritrisGameDelegate

- (void)maritrisGameDidStart:(EMIMaritrisGame *)game {
    // TODO: Update labels etc.
    self.scene.updateLengthMilliseconds = kEMIUpdateIntervalMillisecondsLevelOne;
    
    if (nil != game.nextShape && nil == [[game.nextShape.blocks firstObject] sprite]) {
        EMIWeakify(self);
        [self.scene addPreviewShapeToScene:self.gameLogic.nextShape completion:^{
            EMIStrongifyAndReturnIfNil(self);
            [self nextShape];
        }];
    } else {
        [self nextShape];
    }
}

- (void)maritrisGameDidEnd:(EMIMaritrisGame *)game {
    // TODO: Update labels etc.
    [self.scene stopUpdates];
    [self.scene animateCollapsingLines:[game removeAllLines] fallenBlocks:@[] completion:^{
        [game startGame];
    }];
}

- (void)maritrisGameShapeDidMove:(EMIMaritrisGame *)game {
    if (!self.isUpdating) {
        self.updating = YES;
        [self.scene redrawShape:game.currentShape completion:^{
            self.updating = NO;
        }];
    }
}

- (void)maritrisGameShapeDidDrop:(EMIMaritrisGame *)game {
    [self.scene stopUpdates];
    self.view.userInteractionEnabled = NO;
    [self.scene redrawShape:game.currentShape completion:^{
        [game moveShapeDown];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
    
        });
    }];
}

- (void)maritrisGameShapeDidLand:(EMIMaritrisGame *)game {
    [self.scene stopUpdates];
    self.view.userInteractionEnabled = YES;
    
    [game removeCompletedLinesWithCompletion:^(NSArray *removedLines, NSArray *fallenBlocks) {
        if ([removedLines count] > 0) {
            // update scores label
            [self.scene animateCollapsingLines:removedLines fallenBlocks:fallenBlocks completion:^{
                [self maritrisGameShapeDidLand:game];
            }];
        } else {
            [self nextShape];
        }
    }];
}

- (void)maritrisGameDidIncreaseScore:(EMIMaritrisGame *)game {
    self.scene.scoreLabel.string = [NSString stringWithFormat:@"%@", @(game.score)];
}

- (void)maritrisGameDidLevelUp:(EMIMaritrisGame *)game {
    EMIMainScene *scene = self.scene;
    scene.levelLabel.string = [NSString stringWithFormat:@"%@", @(game.gameLevel)];
    if (scene.updateLengthMilliseconds >= 100) {
        scene.updateLengthMilliseconds -= 100;
    } else if (scene.updateLengthMilliseconds > 50) {
        scene.updateLengthMilliseconds -= 50;
    }
}

#pragma mark -
#pragma mark Private
- (void)nextShape {
    [self.gameLogic moveNextShapeToStart];
    
    if (!self.gameLogic.currentShape) {
        return;
    }
    
    if (nil == [self.gameLogic.nextShape.blocks.firstObject sprite]) {
        [self.scene addPreviewShapeToScene:self.gameLogic.nextShape completion:nil];
    }
    
    [self.scene movePreviewShapeToBoard:self.gameLogic.currentShape completion:^{
        self.view.userInteractionEnabled = YES;
        [self.scene startUpdates];
    }];
}

- (void)setUpView {
    UIView *view = [[CCDirector sharedDirector] view];
    self.view = view;
    view.multipleTouchEnabled = NO;

    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [view addGestureRecognizer:tapGestureRecognizer];

    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [view addGestureRecognizer:panGestureRecognizer];

    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleSwipeGesture:)];
    swipeGestureRecognizer.delegate = self;
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:swipeGestureRecognizer];
}

#pragma mark -
#pragma mark Touches Handler

- (void)handleTapGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer {
    NSLog(@"Did Tap!");
    [self.gameLogic rotateShape];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer*)aPanGestureRecognizer {
    NSLog(@"Did Swipe!");
    [self.gameLogic dropShape];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) ||
        ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])) {
            return NO;
    }
    return YES;
}

- (BOOL)                gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            return YES;
        }
    } else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)aSender {
    CGPoint currentPoint = [aSender translationInView:aSender.view];
    if (currentPoint.y != 0) {
        currentPoint.y *= -1;
    }
    
    if (!CGPointEqualToPoint(self.lastPanLocation, CGPointZero)) {
        CGFloat velocity = [aSender velocityInView:aSender.view].x;
        NSLog(@"velocity: %@", @(velocity));
        if (ABS(currentPoint.x - self.lastPanLocation.x) > kEMIBlockSize) {
            NSLog(@"Did Pan!");
            if (velocity > 0.0f) {
                [self.gameLogic moveShapeRight];
                self.lastPanLocation = currentPoint;
            } else {
                [self.gameLogic moveShapeLeft];
                self.lastPanLocation = currentPoint;
            }
        }
    } else if (aSender.state == UIGestureRecognizerStateBegan
        || CGPointEqualToPoint(self.lastPanLocation, CGPointZero)) {
        self.lastPanLocation = currentPoint;
    }
}

@end
