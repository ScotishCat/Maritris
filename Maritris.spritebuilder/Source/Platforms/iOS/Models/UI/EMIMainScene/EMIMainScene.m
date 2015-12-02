#import "EMIMainScene.h"

#import "EMIMaritrisGame.h"
#import "EMIBlock.h"
#import "EMIBlockPosition.h"
#import "EMIShape.h"

#import "EMIMacros.h"

static const CGFloat        kEMIBlockSize                           = 15.0f;
static const NSTimeInterval kEMIUpdateIntervalMillisecondsLevelOne  = 600.0f;

@interface EMIMainScene () <EMIMaritrisGameDelegate>
@property (nonatomic, strong)   EMIMaritrisGame     *gameLogic;
@property (nonatomic, strong)   CCNode              *gameLayer;
@property (nonatomic, strong)   CCNode              *shapeLayer;
@property (nonatomic, assign)   CGPoint             layerPosition;
@property (nonatomic, assign)   NSTimeInterval      updateLengthMilliseconds;
@property (nonatomic, copy)     NSDate              *lastUpdate;
@property (nonatomic, strong)   NSMutableDictionary *textureChache;
@property (nonatomic, assign)   CGPoint             lastTouchLocation;

@property (nonatomic, assign, getter=isDraggingInProgress) BOOL draggingInProgress;

- (void)performGameUpdate;
- (void)animateCollapsingLines:(NSArray *)removedLines
                  fallenBlocks:(NSArray *)fallenBlocks
                    completion:(dispatch_block_t)completion;

@end

@implementation EMIMainScene

- (instancetype)init {
    self = [super init];
    if (self) {
        self.gameLogic = [EMIMaritrisGame new];
        self.gameLogic.delegate = self;
        self.layerPosition = ccp(5.0f, -5.0f);
        self.gameLayer = [CCNode node];
        self.shapeLayer = [CCNode node];
        self.textureChache = [NSMutableDictionary dictionary];
        self.userInteractionEnabled = YES;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self addChild:self.gameLayer];
            CCNode *gameBoard = [CCNode node];
            gameBoard.contentSize = CGSizeMake(kEMIBlockSize * kEMIGameNumberOfColumns, kEMIBlockSize * kEMIGameNumberOfRows);
            gameBoard.anchorPoint = ccp(0, 1);
            gameBoard.position = self.layerPosition;
            
            self.shapeLayer.position = self.layerPosition;
            [self.shapeLayer addChild:gameBoard];
            [self.gameLayer addChild:self.shapeLayer];
            
            [self.gameLogic startGame];
        });
    }
    
    return self;
}

- (void)update:(CCTime)delta {
    if (!self.lastUpdate) {
        return;
    }
    
    NSTimeInterval timePassed = self.lastUpdate.timeIntervalSinceNow * -1000.0;
    if (timePassed > self.updateLengthMilliseconds) {
        self.lastUpdate = [NSDate date];
        [self performGameUpdate];
    }
}

- (void)startUpdates {
    self.lastUpdate = [NSDate date];
}

- (void)stopUpdates {
    self.lastUpdate = nil;
}

#pragma mark -
#pragma mark EMIMaritrisGameDelegate

- (void)maritrisGameDidStart:(EMIMaritrisGame *)game {
    // TODO: Update labels etc.
    self.updateLengthMilliseconds = kEMIUpdateIntervalMillisecondsLevelOne;
    
    if (nil != game.nextShape && nil == [[game.nextShape.blocks firstObject] sprite]) {
        EMIWeakify(self);
        [self addPreviewShapeToScene:self.gameLogic.nextShape completion:^{
            EMIStrongifyAndReturnIfNil(self);
            [self nextShape];
        }];
    } else {
        [self nextShape];
    }
}

- (void)maritrisGameDidEnd:(EMIMaritrisGame *)game {
    // TODO: Update labels etc.
    [self stopUpdates];
    [self animateCollapsingLines:[game removeAllLines] fallenBlocks:@[] completion:^{
        [game startGame];
    }];
}

- (void)maritrisGameShapeDidMove:(EMIMaritrisGame *)game {
    [self redrawShape:game.currentShape completion:nil];
}

- (void)maritrisGameShapeDidDrop:(EMIMaritrisGame *)game {
    [self stopUpdates];
    [self redrawShape:game.currentShape completion:^{
        [game moveShapeDown];
    }];
}

- (void)maritrisGameShapeDidLand:(EMIMaritrisGame *)game {
    [self stopUpdates];
    [game removeCompletedLinesWithCompletion:^(NSArray *removedLines, NSArray *fallenBlocks) {
        if ([removedLines count] > 0) {
            // update scores label
            [self animateCollapsingLines:removedLines fallenBlocks:fallenBlocks completion:^{
                [self maritrisGameShapeDidLand:game];
            }];
        } else {
            [self nextShape];
        }
    }];
}

#pragma mark -
#pragma mark Private

- (CGPoint)pointForColumn:(NSUInteger)column row:(NSUInteger)row {
    CGFloat x = floor(self.layerPosition.x + ((CGFloat)column  * kEMIBlockSize) + (kEMIBlockSize * 0.5));
    
    CGFloat boardHeight = kEMIGameNumberOfRows * kEMIBlockSize;
    CGFloat y = floor(boardHeight - self.layerPosition.y - ((CGFloat)row  * kEMIBlockSize) + (kEMIBlockSize * 0.5));
    
    return CGPointMake(x, y);
}

- (void)nextShape {
    [self.gameLogic moveNextShapeToStart];
    
    if (!self.gameLogic.currentShape) {
        return;
    }
    
    if (nil == [self.gameLogic.nextShape.blocks.firstObject sprite]) {
        [self addPreviewShapeToScene:self.gameLogic.nextShape completion:nil];
    }
    
    [self movePreviewShapeToBoard:self.gameLogic.currentShape completion:^{
        [self startUpdates];
    }];
}

- (void)redrawShape:(EMIShape *)shape completion:(dispatch_block_t)completion {
    const NSTimeInterval animationDuration = 0.05;
    for (EMIBlock *block in shape.blocks) {
        id sprite = block.sprite;
        CCAction *moveAction = [CCActionMoveTo actionWithDuration:animationDuration
                                                         position:[self pointForColumn:block.column row:block.row]];
        [sprite runAction:moveAction];
    }
    
    [self callCompletion:completion withDelay:animationDuration];
}

- (void)movePreviewShapeToBoard:(EMIShape *)shape completion:(dispatch_block_t)completion {
    const NSTimeInterval animationDuration = 0.2;
    for (EMIBlock *block in shape.blocks) {
        id sprite = block.sprite;
        CCAction *moveAction = [CCActionMoveTo actionWithDuration:animationDuration
                                                         position:[self pointForColumn:block.column row:block.row]];
        [sprite runAction:moveAction];
    }
    
    [self callCompletion:completion withDelay:animationDuration];
}

- (CCColor *)colorForColor:(EMIBlockColor)color {
    static NSDictionary *sColors = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sColors = @{@(EMIBlockColorBlue) : [CCColor colorWithUIColor:[UIColor blueColor]],
                    @(EMIBlockColorOrange) : [CCColor colorWithUIColor:[UIColor orangeColor]],
                    @(EMIBlockColorPurple) : [CCColor colorWithUIColor:[UIColor purpleColor]],
                    @(EMIBlockColorYellow) : [CCColor colorWithUIColor:[UIColor yellowColor]],
                    @(EMIBlockColorRed) : [CCColor colorWithUIColor:[UIColor redColor]]};
    });
    
    return sColors[@(color)];
}

- (void)addPreviewShapeToScene:(EMIShape *)shape completion:(dispatch_block_t)completion {
    const NSTimeInterval animationDuration = 0.2;
    for (EMIBlock *block in shape.blocks) {
        // TODO: Use texture here
        //        CCNode *texture = self.textureChache[block.spriteName];
        //        if (!texture) {
        //        }
        CCNode *sprite = [CCNodeColor nodeWithColor:[self colorForColor:block.color]];
        
        sprite.contentSize = CGSizeMake(kEMIBlockSize, kEMIBlockSize);
        sprite.position = [self pointForColumn:block.column row:block.row];
        [self.shapeLayer addChild:sprite];
        block.sprite = sprite;
        
        // Animation
        sprite.opacity = 0.0;
        CCAction *moveAction = [CCActionMoveTo actionWithDuration:animationDuration
                                                         position:[self pointForColumn:block.column row:block.row]];
        // moveAction
        CCAction *fadeAction = [CCActionFadeIn actionWithDuration:animationDuration];
        CCAction *spawnAction = [CCActionSpawn actionWithArray:@[moveAction, fadeAction]];
        [sprite runAction:spawnAction];
    }
    
    [self callCompletion:completion withDelay:animationDuration];
}

- (void)callCompletion:(dispatch_block_t)completion withDelay:(NSTimeInterval)delay {
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.21 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)performGameUpdate {
    [self.gameLogic moveShapeDown];
}

- (void)animateCollapsingLines:(NSArray *)removedLines
                  fallenBlocks:(NSArray *)fallenBlocks
                    completion:(dispatch_block_t)completion
{
    NSTimeInterval longestDuration = 0.0;
    
    for (NSUInteger columnIndex = 0; columnIndex < [fallenBlocks count]; columnIndex++) {
        NSArray *column = fallenBlocks[columnIndex];
        for (NSUInteger blockIndex = 0; blockIndex < [column count]; blockIndex++) {
            EMIBlock *block = column[blockIndex];
            CGPoint newPosition = [self pointForColumn:block.column row:block.row];
            CCNode *sprite = block.sprite;
            NSTimeInterval delay = columnIndex * 0.05 + blockIndex * 0.05;
            NSTimeInterval duration = ((([sprite position].y - newPosition.y) / kEMIBlockSize) * 0.1);
            CCAction *moveAction = [CCActionMoveTo actionWithDuration:duration position:newPosition];
            CCAction *sequence = [CCActionSequence actionWithArray:
                                  @[[CCActionDelay actionWithDuration:delay], moveAction]];
            [sprite runAction:sequence];
            longestDuration = MAX(longestDuration, (duration + delay));
        }
    }
    
    for (NSArray *rowToRemove in removedLines) {
        for (EMIBlock *block in rowToRemove) {
            CCActionSequence *sequence = [CCActionSequence actionWithArray:
                                          @[[CCActionFadeOut actionWithDuration:0.5], [CCActionRemove action]]];
            [block.sprite runAction:sequence];
        }
    }
    
    [self runAction:[CCActionSequence actionWithArray:
                     @[[CCActionDelay actionWithDuration:longestDuration],
                       [CCActionCallBlock actionWithBlock:completion]]]];
}

#pragma mark -
#pragma mark Touches Handler

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    CCLOG(@"Received a touch at location: %@", NSStringFromCGPoint(touchLocation));
    self.lastTouchLocation = touchLocation;
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint currentLocation = [touch locationInNode:self];
    CGFloat xOffset = currentLocation.x - self.lastTouchLocation.x;
    CGFloat yOffset = currentLocation.y - self.lastTouchLocation.y;
    if (ABS(xOffset) > kEMIBlockSize) {
        self.draggingInProgress = YES;
    
        if (xOffset > 0) {
            [self.gameLogic moveShapeRight];
        } else {
            [self.gameLogic moveShapeLeft];
        }
        
        self.lastTouchLocation = currentLocation;
    }
    
    if (yOffset < kEMIBlockSize * 4) {
        //        [self.gameLogic dropShape];
        self.lastTouchLocation = currentLocation;
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (!self.isDraggingInProgress) {
        [self.gameLogic rotateShape];
    }
    
    self.draggingInProgress = NO;
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (!self.isDraggingInProgress) {
        [self.gameLogic rotateShape];
    }
    
    self.draggingInProgress = NO;
}

@end
