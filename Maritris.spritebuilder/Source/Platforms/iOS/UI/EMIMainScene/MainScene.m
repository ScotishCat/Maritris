#import "MainScene.h"

#import "EMIMaritrisGame.h"
#import "EMIBlock.h"
#import "EMIBlockPosition.h"
#import "EMIShape.h"

static const CGFloat kEMIBlockSize = 20.0f;
static const NSTimeInterval kEMIUpdateIntervalMillisecondsLevelOne = 600.0;

@interface MainScene () <EMIMaritrisGameDelegate>

@property (nonatomic, readonly) EMIMaritrisGame *gameLogic;

@property (nonatomic, readonly) CCNode *gameLayer;
@property (nonatomic, readonly) CCNode *shapeLayer;
@property (nonatomic, readonly) CGPoint layerPosition;

@property (nonatomic, assign) NSTimeInterval updateLengthMilliseconds;

@property (nonatomic, copy) NSDate *lastUpdate;

@property (nonatomic, readonly) NSMutableDictionary *textureChache;

- (void)performGameUpdate;

@end

@implementation MainScene

- (instancetype)init {
    self = [super init];
    if (self) {

    _gameLogic = [EMIMaritrisGame new];
    _gameLogic.delegate = self;
    
//    self.anchorPoint = ccp(0.0, 1.0);
    
    _layerPosition = ccp(6.0f, -6.0f);
    _gameLayer = [CCNode node];
    _shapeLayer = [CCNode node];
    _textureChache = [NSMutableDictionary dictionary];
    
    
        dispatch_async( dispatch_get_main_queue(), ^{

            [self addChild:_gameLayer];
            [_gameLayer addChild:_shapeLayer];
            

            

            CCNode *gameBoard = [CCNode node];
            gameBoard.contentSize = CGSizeMake(kEMIBlockSize * kEMIGameNumberOfColumns, kEMIBlockSize * kEMIGameNumberOfRows);
            gameBoard.anchorPoint = ccp(0, 1);
            gameBoard.position = _layerPosition;
            
            _shapeLayer.position = _layerPosition;
            [_shapeLayer addChild:gameBoard];
            

            CCNodeColor *verticalBorder = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:1]];
            verticalBorder.anchorPoint = ccp(0, 1);
            verticalBorder.contentSize = CGSizeMake(2, 500);
            verticalBorder.position = ccp(10, 500);
            [_shapeLayer addChild:verticalBorder];


            CCNode *block = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];;
            block.contentSize = CGSizeMake(kEMIBlockSize, kEMIBlockSize);
            block.position = [self pointForColumn:10 row:26];
            [_shapeLayer addChild:block];


            CCNode *block2 = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.9f green:0.2f blue:0.2f alpha:1.0f]];;
            block2.contentSize = CGSizeMake(kEMIBlockSize, kEMIBlockSize);
            block2.position = [self pointForColumn:9 row:27];
            [_shapeLayer addChild:block2];
            
            [self.gameLogic startGame];
//            [self.gameLogic moveNextShapeToStart];
        
//            [self removeAllChildren];
//            
//
//            CCSprite *background = [CCSprite spriteWithImageNamed:@"notebook_texture2464.png"];
//            CGSize imageSize = background.contentSize;
//
//            background.anchorPoint = ccp(0, 0);
//
//            CGSize viewSize = [[CCDirector sharedDirector] viewSize];
//            background.scaleX = viewSize.width / imageSize.width;
//            background.scaleY = viewSize.height / imageSize.height;
//            [self addChild:background];
//            background.anchorPoint = CGPointMake(0.0f, 0.0f);
//            [self addChild:background z:0];
        });
    }
    
    return self;
}

- (void)update:(CCTime)delta {
    if (!self.lastUpdate) {
        return;
    }
    
    NSTimeInterval timePassed = self.lastUpdate.timeIntervalSinceNow * -1000.0;
    if (timePassed > kEMIUpdateIntervalMillisecondsLevelOne) {
        [self performGameUpdate];
    }
}

#pragma mark -

- (void)maritrisGameDidStart:(EMIMaritrisGame *)game {
    // TODO: Update labels etc.
    self.updateLengthMilliseconds = kEMIUpdateIntervalMillisecondsLevelOne;
    
    // Add more logic
    
    [self nextShape];
}


#pragma mark -

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
    
    [self addPreviewShapeToScene:self.gameLogic.nextShape completion:nil];
}

- (void)addPreviewShapeToScene:(EMIShape *)shape completion:(dispatch_block_t)completion {
    for (EMIBlock *block in shape.blocks) {
        // TODO: Use texture here
//        CCNode *texture = self.textureChache[block.spriteName];
//        if (!texture) {
//        }
            CCNode *sprite = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.9f green:0.0f blue:0.2f alpha:1.0f]];
        
            sprite.contentSize = CGSizeMake(kEMIBlockSize, kEMIBlockSize);
            sprite.position = [self pointForColumn:block.column row:block.row];
            [self.shapeLayer addChild:sprite];
            block.sprite = sprite;
            
            // Animation
            sprite.opacity = 0.0;
            CCAction *moveAction = [CCActionMoveTo actionWithDuration:0.2
                position:[self pointForColumn:block.column row:block.row]];
//            moveAction.
            CCAction *fadeAction = [CCActionFadeIn actionWithDuration:0.2];
            CCAction *spawnAction = [CCActionSpawn actionWithArray:@[moveAction, fadeAction]];
            [sprite runAction:spawnAction];
    }
    CCAction *delay = [CCActionDelay actionWithDuration:0.2];
    [self runAction:delay];
}

- (void)performGameUpdate {
    [self.gameLogic moveShapeDown];
}

@end

