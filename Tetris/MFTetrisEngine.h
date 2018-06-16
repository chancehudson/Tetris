//
//  MFTetrisEngine.h
//  Tetris
//
//  Created by Chance Hudson on 10/31/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class MFTetrisPieces, MFTetrisPiece;

#define PIECE_BLOCKS 5

@interface MFTetrisEngine : NSObject{
    int board[TETRIS_BOARD_WIDTH][TETRIS_BOARD_HEIGHT];
    MFTetrisPieces *pieces;
    int boardWidth;
    int boardHeight;
}

-(id)initGameWithPieces:(MFTetrisPieces*)p;
-(id)initGameWithPieces:(MFTetrisPieces*)p boardWidth:(int)w boardHeight:(int)h;
-(BOOL)isBlockFreeAtPoint:(TetrisPoint)point;
-(void)storePiece:(MFTetrisPiece*)p;
-(BOOL)isMovementPossible:(TetrisPoint)point piece:(MFTetrisPiece*)piece rotation:(int)rotation;
-(void)deleteLines;
-(BOOL)isGameOver;
-(void)resetGame;

-(int)blockTypeAtX:(int)x Y:(int)y;

@end
