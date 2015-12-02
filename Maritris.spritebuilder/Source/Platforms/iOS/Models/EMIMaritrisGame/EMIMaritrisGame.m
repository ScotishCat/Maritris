//
//  EMIMaritrisGame.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIMaritrisGame.h"

#import "EMIShape.h"
#import "EMIShapeSquare.h"
#import "EMIShape+RandomCreation.h"
#import "EMIBlockPosition.h"
#import "EMIBlock.h"
#import "EMIArray2D.h"

static const NSUInteger kEMIPointsPerLine = 25;
static const NSUInteger kEMIGameLevelThreshold = 1000;

const NSUInteger kEMIGameNumberOfColumns = 13;
const NSUInteger kEMIGameNumberOfRows = 35;

static const NSUInteger kEMIGamePreviewColumnPosition = 16;
static const NSUInteger kEMIGamePreviewRowPosition = 5;

static const NSUInteger kEMIGameStartColumnPosition = 4;
static const NSUInteger kEMIGameStartRowPosition = 2;

@interface EMIMaritrisGame ()
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger gameLevel;

@property (nonatomic, strong) EMIShape *currentShape;
@property (nonatomic, strong) EMIShape *nextShape;

@property (nonatomic, strong) EMIArray2D *blocksGrid;

@property (nonatomic, readonly) EMIBlockPosition *startPosition;
@property (nonatomic, readonly) EMIBlockPosition *previewPosition;

@property (nonatomic, readonly) BOOL isCurrentShapeInValidPosition;
@property (nonatomic, readonly) BOOL isCurrentShapeOnTopOfOthers;

// Creates and returns new random Shape at (kEMIGamePreviewColumnPosition, kEMIGamePreviewRowPosition)
- (EMIShape *)newRandomShapeForPreview;

- (void)settleCurrentShape;
- (void)notifyWithSelector:(SEL)selector;

@end

@implementation EMIMaritrisGame

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.score = 0;
        self.gameLevel = 1;
        self.blocksGrid = [EMIArray2D arrayWithColumnsNumber:kEMIGameNumberOfColumns rowsNumber:kEMIGameNumberOfRows];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (EMIBlockPosition *)startPosition {
    return [EMIBlockPosition positionWithColumn:kEMIGameStartColumnPosition row:kEMIGameStartRowPosition];
}

- (EMIBlockPosition *)previewPosition {
    return [EMIBlockPosition positionWithColumn:kEMIGamePreviewColumnPosition row:kEMIGamePreviewRowPosition];
}

- (BOOL)isCurrentShapeInValidPosition {
    if (!self.currentShape) {
        return YES;
    }
    
    for (EMIBlock *currentBlock in self.currentShape.blocks) {
        if (currentBlock.column < 0 || currentBlock.column >= kEMIGameNumberOfColumns
            || currentBlock.row < 0 || currentBlock.row >= kEMIGameNumberOfRows) {
            return NO;
        } else if ([self.blocksGrid objectAtColumn:currentBlock.column row:currentBlock.row] != [NSNull null]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isCurrentShapeOnTopOfOthers {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return NO;
    }
    
    EMIArray2D *blocksGrid = self.blocksGrid;
    for (EMIBlock *bottomBlock in currentShape.bottomBlocks) {
        if ((bottomBlock.row == kEMIGameNumberOfRows - 1) || [blocksGrid objectAtColumn:bottomBlock.column row:bottomBlock.row + 1] != [NSNull null]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark Public

- (void)moveNextShapeToStart {
    // Update current shapes
    self.currentShape = self.nextShape;
    self.nextShape = [self newRandomShapeForPreview];
    
    // Move current shape to start
    [self.currentShape moveToPosition:self.startPosition];
    
    // If current shape is in invalid position, game over - reset the game and notify delegate
    if (!self.isCurrentShapeInValidPosition) {
        self.nextShape = self.currentShape;
        [self.nextShape moveToPosition:self.previewPosition];
        
        [self endGame];
    }
}

- (void)startGame {
    if (!self.nextShape) {
        self.nextShape = [self newRandomShapeForPreview];
    }
    
    [self notifyWithSelector:@selector(maritrisGameDidStart:)];
}

- (void)endGame {
    self.score = 0;
    self.gameLevel = 1;
    
    [self notifyWithSelector:@selector(maritrisGameDidEnd:)];
}

- (void)moveShapeDown {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return;
    }
    
    // First try to move the shape down
    [currentShape moveDownOneRow];
    if (!self.isCurrentShapeInValidPosition) {
        // If it's position is not valid, move it up and check again
        [currentShape moveUpOneRow];
        if (!self.isCurrentShapeInValidPosition) {
            // The position is still invalid, so the game is over
            [self endGame];
        } else {
            // We've reached the bottom, fill the grid of blocks
            [self settleCurrentShape];
        }
    } else {
        [self notifyWithSelector:@selector(maritrisGameShapeDidMove:)];
        if (self.isCurrentShapeOnTopOfOthers) {
            // Current shape has fallen down on other blocks on the grid, so stop it and fill the grid with shape's blocks
            [self settleCurrentShape];
        }
    }
}

- (void)dropShape {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return;
    }

    while (self.isCurrentShapeInValidPosition) {
        [currentShape moveDownOneRow];
    }
    
    [currentShape moveUpOneRow];
    [self notifyWithSelector:@selector(maritrisGameShapeDidDrop:)];
}

- (void)rotateShape {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return;
    }

    [currentShape rotateRight];
    if (!self.isCurrentShapeInValidPosition) {
        [currentShape rotateLeft];
        return;
    }
    
    [self notifyWithSelector:@selector(maritrisGameShapeDidMove:)];
}

- (void)moveShapeLeft {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return;
    }

    [currentShape moveLeftOneColumn];
    if (!self.isCurrentShapeInValidPosition) {
        [currentShape moveRightOneColumn];
        return;
    }
    
    [self notifyWithSelector:@selector(maritrisGameShapeDidMove:)];
}

- (void)moveShapeRight {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return;
    }

    [currentShape moveRightOneColumn];
    if (!self.isCurrentShapeInValidPosition) {
        [currentShape moveLeftOneColumn];
        return;
    }
    
    [self notifyWithSelector:@selector(maritrisGameShapeDidMove:)];
}

- (void)removeCompletedLinesWithCompletion:(EMIRemoveCompletedLinesCompletion)completion {
    EMIArray2D *gridOfBlocks = self.blocksGrid;

    NSMutableArray *removedLines = [NSMutableArray array];
    // Iterate over the each row in the game and check if it has any blocks filled
    for (NSInteger rowIndex = kEMIGameNumberOfRows - 1; rowIndex > 0; rowIndex--) {
        NSMutableArray *rowOfBlocks = [NSMutableArray arrayWithCapacity:kEMIGameNumberOfColumns];
        for (NSUInteger columnIndex = 0; columnIndex < kEMIGameNumberOfColumns; columnIndex++) {
            id block = [gridOfBlocks objectAtColumn:columnIndex row:rowIndex];
            if (block == [NSNull null]) {
                // no block at this place, so row is not full - continue
                continue;
            }
            [rowOfBlocks addObject:block];
        }
        if ([rowOfBlocks count] == kEMIGameNumberOfColumns) {
            // We have a full row filled - add it to results array
            [removedLines addObject:rowOfBlocks];
            // Clear the removed blocks from the grid
            for (EMIBlock *block in rowOfBlocks) {
                [gridOfBlocks setObject:[NSNull null] atColumn:block.column row:block.row];
            }
        }
    }
    
    // If nothing was removed, exit method
    if (0 == [removedLines count]) {
        if (completion) {
            completion(nil, nil);
        }
        return;
    }
    
    // Update scores
    NSUInteger earnedPoints = [removedLines count] * kEMIPointsPerLine * self.gameLevel;
    self.score += earnedPoints;
    [self notifyWithSelector:@selector(maritrisGameDidIncreaseScore:)];
    if (self.score >= self.gameLevel * kEMIGameLevelThreshold) {
        self.gameLevel += 1;
        [self notifyWithSelector:@selector(maritrisGameDidLevelUp:)];
    }
    
    NSMutableArray *fallenBlocks = [NSMutableArray array];
    
    // Now adjust all blocks that are above our removed lines and should fall down.
    // Start from the left-most column.
    for (NSUInteger columnIndex = 0; columnIndex < kEMIGameNumberOfColumns; columnIndex++) {
    
        NSMutableArray *fallenBlocksArray = [NSMutableArray array];
        // Get the index of the first row above the first removed line
        NSUInteger rowIndex = [[removedLines[0] objectAtIndex:0] row] - 1;
        // And iterate upwards to find the closest filled block
        for (; rowIndex > 0; rowIndex--) {
            EMIBlock *block = [gridOfBlocks objectAtColumn:columnIndex row:rowIndex];
            if ([block isKindOfClass:[NSNull class]]) {
                // This position is empty, skip it
                continue;
            }
            
            // Find the next position of the row - how far down we should move it
            NSUInteger newRow = rowIndex;
            while (newRow < kEMIGameNumberOfRows - 1 && [NSNull null] == [gridOfBlocks objectAtColumn:columnIndex row:newRow + 1]) {
                newRow++;
            }
            
            // Adjust block's row (move it down as needed)
            block.row = newRow;
            // Mark old position empty on the grid
            [gridOfBlocks setObject:[NSNull null] atColumn:columnIndex row:rowIndex];
            // Mark new position filled
            [gridOfBlocks setObject:block atColumn:columnIndex row:newRow];
            [fallenBlocksArray addObject:block];
        }
        if ([fallenBlocksArray count] > 0) {
            [fallenBlocks addObject:fallenBlocksArray];
        }
    }
    
    if (completion) {
        completion(removedLines, fallenBlocks);
    }
}

- (NSArray *)removeAllLines {
    NSMutableArray *allBlocks = [NSMutableArray array];
    
    EMIArray2D *gridOfBlocks = self.blocksGrid;
    for (NSUInteger rowIndex = 0; rowIndex < kEMIGameNumberOfRows; rowIndex++) {
    
        NSMutableArray *rowOfBlocks = [NSMutableArray array];
        for (NSUInteger columnIndex = 0; columnIndex < kEMIGameNumberOfColumns; columnIndex++) {
        
            EMIBlock *block = [gridOfBlocks objectAtColumn:columnIndex row:rowIndex];
            if (![block isKindOfClass:[NSNull class]]) {
                [rowOfBlocks addObject:block];
                [gridOfBlocks setObject:[NSNull null] atColumn:columnIndex row:rowIndex];
            }
        }
        [allBlocks addObject:rowOfBlocks];
    }
    
    return allBlocks;
}

#pragma mark -
#pragma mark Private

- (EMIShape *)newRandomShapeForPreview {
    return [EMIShape randomShapeWithPosition:self.previewPosition];
}

- (void)settleCurrentShape {
    EMIShape *currentShape = self.currentShape;
    if (!currentShape) {
        return;
    }
    
    EMIArray2D *blocksGrid = self.blocksGrid;
    // Update our grid with the blocks of the current shape
    for (EMIBlock *block in currentShape.blocks) {
        [blocksGrid setObject:block atColumn:block.column row:block.row];
    }
    
    self.currentShape = nil;
    [self notifyWithSelector:@selector(maritrisGameShapeDidLand:)];
}

- (void)notifyWithSelector:(SEL)selector {
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate performSelector:selector withObject:self];
    }
}

@end

