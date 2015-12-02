//
//  EMIMaritrisGame.h
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMIMaritrisGameDelegate;
@class EMIShape;

extern const NSUInteger kEMIGameNumberOfColumns;
extern const NSUInteger kEMIGameNumberOfRows;


/* Represents abstract implementation of tetris game logic
    The game object handles various tasks as tracking the current and next shape,
    scores and game level. It notifies delegate about all steps and changes of the game.
    It doesn't act by itself and should be controlled
    The basic flow of events is the following:
    1. Create EMIMaritrisGame and set its delegate.
    2. -startGame
    3. When the game begins, and each time after shape lands, call -moveNextShapeToStart to set current shape at start position
    4. At specific time intervals (they should depend on the -gameLevel value), call moveShapeDown.
        * The game will notify its delegate when positions and rotation of current shape changes, and the delegate is responsible for updating the UI accordingly
        * Delegate should call -dropShape, -rotateShape, -moveShapeLeft, -moveShapeRight based on user input or whenever needed.
        * Delegate gets notified whenever the current shape lands, drops, moves, when the score or level increases. In response the delegate should update visual representations as needed, play sounds if needed, etc.
        * Delegate should call -removeCompletedLinesWithCompletion: each time the -maritrisGameShapeDidLand: method called.
    5. -endGame
*/

// A completion for the -removeCompletedLinesWithCompletion:
// Both params are arrays that contain arrays of EMIBlock objects.
// removedLines is an array of removed lines, where each line is an array of blocks.
// fallenBlocks is an array of sub-arrays, where sub-array represents columns of blocks that fall down.

typedef void(^EMIRemoveCompletedLinesCompletion)(NSArray *removedLines, NSArray *fallenBlocks);

@interface EMIMaritrisGame : NSObject

@property (nonatomic, weak) id<EMIMaritrisGameDelegate> delegate;

@property (nonatomic, readonly, assign) NSUInteger score;
@property (nonatomic, readonly, assign) NSUInteger gameLevel;

@property (nonatomic, readonly, strong) EMIShape *currentShape;
@property (nonatomic, readonly, strong) EMIShape *nextShape;

- (void)startGame;
- (void)endGame;

// Sets the next shape to be the current one, generates new next shape
- (void)moveNextShapeToStart;

// The following methods handle moves and rotations of current shape.
// The delegate gets called at appropriate times to update visual representations as needed.
- (void)moveShapeDown;
- (void)dropShape;
- (void)rotateShape;
- (void)moveShapeLeft;
- (void)moveShapeRight;

// Removes all completed lines and drops all blocks that are above the top-most row down.
// Returns in completion block an array of removed lines (each line is array of EMIBlock) and array of dropped blocks that were moved down
- (void)removeCompletedLinesWithCompletion:(EMIRemoveCompletedLinesCompletion)completion;

// Removes all lines from the grid, and returns array of sub-arrays which represent rows of EMIBlock objects.
- (NSArray *)removeAllLines;

@end

// A protocol for game's delegates
@protocol EMIMaritrisGameDelegate <NSObject>

@optional

- (void)maritrisGameDidStart:(EMIMaritrisGame *)game;
- (void)maritrisGameDidEnd:(EMIMaritrisGame *)game;

// Called when current shape actually settled down
- (void)maritrisGameShapeDidLand:(EMIMaritrisGame *)game;
// Called each time when postion or rotation of the shape changes
- (void)maritrisGameShapeDidMove:(EMIMaritrisGame *)game;
// Called before maritrisGameShapeDidLand: when current shape was forcefully dropped down by user (typically by swiping it down)
- (void)maritrisGameShapeDidDrop:(EMIMaritrisGame *)game;

- (void)maritrisGameDidIncreaseScore:(EMIMaritrisGame *)game;
- (void)maritrisGameDidLevelUp:(EMIMaritrisGame *)game;

@end