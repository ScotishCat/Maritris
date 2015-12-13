#import "EMIMainScene.h"

#import "EMIMaritrisGame.h"
#import "EMIBlock.h"
#import "EMIBlockPosition.h"
#import "EMIShape.h"

#import "EMIMaritrisViewModel.h"
#import "EMITransitionManager.h"

#import "EMIMacros.h"

const           CGFloat         kEMIBlockSize                   = 15.0f;
static const    NSTimeInterval  kEMIMillisecondsInSecond        = -1000.0;
static const    NSTimeInterval  kEMIRedrawAnimationDuration     = 0.05;
static const    NSTimeInterval  kEMIFadeAnimationDuration       = 0.5;
static const    NSTimeInterval  kEMICollapseAnimationDuration   = 0.1;
static NSString *   const       kEMIQuitAction                  = @"Quit";
static NSString *   const       kEMIAlertControllerQuitTitle    = @"Are you sure you want to quit?";
static NSString *   const       kEMIAlertControllerQuitMessage  = @"Your progress will be lost.";
static NSString *   const       kEMIAlertControllerResumeTitle  = @"Resume";

@interface EMIMainScene () <EMIMaritrisGameDelegate>
@property (nonatomic, strong)   EMIMaritrisViewModel    *viewModel;
@property (nonatomic, strong)   CCNode                  *gameLayer;
@property (nonatomic, strong)   CCNode                  *shapeLayer;
@property (nonatomic, strong)   CCNode                  *gameBoardLayer;
@property (nonatomic, assign)   CGPoint                 layerPosition;
@property (nonatomic, copy)     NSDate                  *lastUpdate;
@property (nonatomic, strong)   NSMutableDictionary     *textureChache;
@property (nonatomic, strong)   CCLabelTTF              *scoreLabel;
@property (nonatomic, strong)   CCLabelTTF              *levelLabel;

- (void)update:(CCTime)delta;

- (CGPoint)pointForColumn:(NSUInteger)column row:(NSUInteger)row;
- (CCAction *)actionByCombiningActions:(NSArray *)actions withCompletion:(dispatch_block_t)completion;

- (CCColor *)colorForColor:(EMIBlockColor)color;
- (void)callCompletion:(dispatch_block_t)completion withDelay:(NSTimeInterval)delay;

@end

@implementation EMIMainScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layerPosition = ccp(5.0f, -5.0f);
        self.gameLayer = [CCNode node];
        self.shapeLayer = [CCNode node];
        self.textureChache = [NSMutableDictionary dictionary];
        self.userInteractionEnabled = YES;
                
        dispatch_async( dispatch_get_main_queue(), ^{
            self.viewModel = [[EMIMaritrisViewModel alloc] initWithScene:self];
            
            [self addChild:self.gameLayer];
            self.scoreLabel.string = @"0";
            self.levelLabel.string = @"1";
            
            CCNode *gameBoard = [CCNode node];
            gameBoard.contentSize = CGSizeMake(kEMIBlockSize * kEMIGameNumberOfColumns, kEMIBlockSize * kEMIGameNumberOfRows);
            gameBoard.anchorPoint = ccp(0, 1);
            gameBoard.position = self.layerPosition;
            self.gameBoardLayer = gameBoard;
            
            self.shapeLayer.position = self.layerPosition;
            [self.shapeLayer addChild:gameBoard];
            [self.gameLayer addChild:self.shapeLayer];
        });
    }
    
    return self;
}

#pragma mark -
#pragma mark Public

- (void)startUpdates {
    self.lastUpdate = [NSDate date];
}

- (void)stopUpdates {
    self.lastUpdate = nil;
}

- (BOOL)isUpdating {
    return (nil != self.lastUpdate);
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
        [sprite runAction:moveAction];
        [sprite runAction:fadeAction];
    }
    
    [self callCompletion:completion withDelay:animationDuration];
}

- (void)movePreviewShapeToBoard:(EMIShape *)shape completion:(dispatch_block_t)completion {
    const NSTimeInterval animationDuration = 0.2;
    for (EMIBlock *block in shape.blocks) {
        id sprite = block.sprite;
        CCAction *moveAction = [CCActionMoveTo actionWithDuration:animationDuration
                                                         position:[self pointForColumn:block.column row:block.row]];
        if (block == shape.blocks.lastObject) {
            moveAction = [self actionByCombiningActions:@[moveAction] withCompletion:completion];
        }
        
        [sprite runAction:moveAction];
    }
}

- (void)redrawShape:(EMIShape *)shape completion:(dispatch_block_t)completion {
    const NSTimeInterval animationDuration = kEMIRedrawAnimationDuration;
    for (EMIBlock *block in shape.blocks) {
        id sprite = block.sprite;
        NSInteger column = block.column;
        if (column < 0) {
            column = 0;
        } else if (column >= kEMIGameNumberOfColumns) {
            column = kEMIGameNumberOfColumns - 1;
        }
        
        CCAction *moveAction = [CCActionMoveTo actionWithDuration:animationDuration
                                                         position:[self pointForColumn:block.column row:block.row]];
        if (block == shape.blocks.lastObject) {
            moveAction = [self actionByCombiningActions:@[moveAction] withCompletion:^{
                for (EMIBlock *block in shape.blocks) {
                    CCNode *sprite = block.sprite;
                    sprite.position = [self pointForColumn:block.column row:block.row];
                }
                
                if (completion) {
                    completion();
                }}];
        }
        
        [sprite runAction:moveAction];
    }
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
            NSTimeInterval delay = columnIndex * kEMIRedrawAnimationDuration + blockIndex * kEMIRedrawAnimationDuration;
            NSTimeInterval duration = ((([sprite position].y - newPosition.y) / kEMIBlockSize) * kEMICollapseAnimationDuration);
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
                                          @[[CCActionFadeOut actionWithDuration:kEMIFadeAnimationDuration], [CCActionRemove action]]];
            [block.sprite runAction:sequence];
        }
    }
    
    [self runAction:[CCActionSequence actionWithArray:
                     @[[CCActionDelay actionWithDuration:longestDuration],
                       [CCActionCallBlock actionWithBlock:completion]]]];
}

#pragma mark - 
#pragma mark Interface Handlers

- (void)onQuitButton {
    NSLog(@"Quit called");
    [[CCDirector sharedDirector] pause];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:kEMIAlertControllerQuitTitle
                                                                        message:kEMIAlertControllerQuitMessage
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:kEMIQuitAction
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction *action) {
                                                           [[CCDirector sharedDirector] popToRootScene];
                                                           [[CCDirector sharedDirector] resume];
                                                       }];
                                                    [controller addAction:quitAction];

    UIAlertAction *resumeAction = [UIAlertAction actionWithTitle:kEMIAlertControllerResumeTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                                [[CCDirector sharedDirector] resume];
                                                            }];
                                                            [controller addAction:resumeAction];
    
    [[EMITransitionManager sharedTransitionManager].navController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 
#pragma mark Private

- (CGPoint)pointForColumn:(NSUInteger)column row:(NSUInteger)row {
    CGFloat x = floor(self.layerPosition.x + ((CGFloat)column  * kEMIBlockSize) + (kEMIBlockSize * 0.5));
    
    CGFloat boardHeight = kEMIGameNumberOfRows * kEMIBlockSize;
    CGFloat y = floor(boardHeight - self.layerPosition.y - ((CGFloat)row  * kEMIBlockSize) + (kEMIBlockSize * 0.5));
    
    return CGPointMake(x, y);
}

- (CCAction *)actionByCombiningActions:(NSArray *)actions withCompletion:(dispatch_block_t)completion {
    NSMutableArray *newActions = [NSMutableArray arrayWithArray:actions];
    [newActions addObject:[CCActionCallBlock actionWithBlock:^{
        if (completion) {
            completion();
        }}]];
    
    CCAction *result = [CCActionSequence actionWithArray:newActions];
    
    return result;
}

- (CCColor *)colorForColor:(EMIBlockColor)color {
    static NSDictionary *sColors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sColors = @{@(EMIBlockColorBlue) : [CCColor colorWithUIColor:[UIColor blueColor]],
                    @(EMIBlockColorMagenta) : [CCColor colorWithUIColor:[UIColor magentaColor]],
                    @(EMIBlockColorOrange) : [CCColor colorWithUIColor:[UIColor orangeColor]],
                    @(EMIBlockColorPurple) : [CCColor colorWithUIColor:[UIColor purpleColor]],
                    @(EMIBlockColorYellow) : [CCColor colorWithUIColor:[UIColor yellowColor]],
                    @(EMIBlockColorRed) : [CCColor colorWithUIColor:[UIColor redColor]]};
    });
    
    return sColors[@(color)];
}

- (void)callCompletion:(dispatch_block_t)completion withDelay:(NSTimeInterval)delay {
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)update:(CCTime)delta {
    if (!self.lastUpdate) {
        return;
    }
    
    NSTimeInterval timePassed = self.lastUpdate.timeIntervalSinceNow * kEMIMillisecondsInSecond;
    if (timePassed > self.updateLengthMilliseconds) {
        self.lastUpdate = [NSDate date];
        [self.viewModel performGameUpdate];
    }
}

@end
