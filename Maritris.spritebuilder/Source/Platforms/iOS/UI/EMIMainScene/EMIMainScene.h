@class EMIShape;

extern const CGFloat kEMIBlockSize;

@interface EMIMainScene : CCNode
@property (nonatomic, assign)           NSTimeInterval      updateLengthMilliseconds;
@property (nonatomic, readonly, copy)   NSDate              *lastUpdate;

@property (nonatomic, readonly, strong)   CCLabelTTF          *scoreLabel;
@property (nonatomic, readonly, strong)   CCLabelTTF          *levelLabel;
@property (nonatomic, readonly, strong)   CCNode              *gameBoardLayer;

- (void)startUpdates;
- (void)stopUpdates;

- (void)addPreviewShapeToScene:(EMIShape *)shape completion:(dispatch_block_t)completion;
- (void)movePreviewShapeToBoard:(EMIShape *)shape completion:(dispatch_block_t)completion;
- (void)animateCollapsingLines:(NSArray *)removedLines
                  fallenBlocks:(NSArray *)fallenBlocks
                    completion:(dispatch_block_t)completion;
- (void)redrawShape:(EMIShape *)shape completion:(dispatch_block_t)completion;

- (void)onQuitButton;

@end
