//
//  MFTetrisEngine.m
//  Tetris
//
//  Created by Chance Hudson on 10/31/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import "MFTetrisEngine.h"
#import "MFTetrisPiece.h"
#import "MFTetrisPieces.h"

@interface MFTetrisEngine (Private)

-(void)deleteLine:(int)y;

@end

@implementation MFTetrisEngine

-(id)initGameWithPieces:(MFTetrisPieces*)p{
    if((self = [super init])){
        pieces = [p retain];
        boardWidth = TETRIS_BOARD_WIDTH;
        boardHeight = TETRIS_BOARD_HEIGHT;
        if(boardHeight > TETRIS_MAX_BOARD_HEIGHT)
            boardHeight = TETRIS_MAX_BOARD_HEIGHT;
        if(boardWidth > TETRIS_MAX_BOARD_WIDTH)
            boardWidth = TETRIS_MAX_BOARD_WIDTH;
        for (int i = 0; i < boardWidth; i++)
            for (int j = 0; j < boardHeight; j++)
                board[i][j] = POS_FREE;
    }
    return self;
}

-(id)initGameWithPieces:(MFTetrisPieces*)p boardWidth:(int)w boardHeight:(int)h{
    if((self = [super init])){
        pieces = [p retain];
        boardWidth = w;
        boardHeight = h;
        if(boardHeight > TETRIS_MAX_BOARD_HEIGHT)
            boardHeight = TETRIS_MAX_BOARD_HEIGHT;
        if(boardWidth > TETRIS_MAX_BOARD_WIDTH)
            boardWidth = TETRIS_MAX_BOARD_WIDTH;
        for (int i = 0; i < boardWidth; i++)
            for (int j = 0; j < boardHeight; j++)
                board[i][j] = POS_FREE;
    }
    return self;
}

-(void)storePiece:(MFTetrisPiece *)p{
    for (int i1 = [p getPosition].x, i2 = 0; i1 < [p getPosition].x + PIECE_BLOCKS; i1++, i2++)
    {
        for (int j1 = [p getPosition].y, j2 = 0; j1 < [p getPosition].y + PIECE_BLOCKS; j1++, j2++)
        {
            // Store only the blocks of the piece that are not holes
            if ([pieces getBlockType:p.pieceType rotation:p.rotation x:i2 y:j2] != 0){
                board[i1][j1] = p.pieceType;
            }
        }
    }
}

-(BOOL)isGameOver{
    //If the first line has blocks, then, game over
    for (int i = 0; i < boardWidth; i++)
    {
        if (board[i][0] != POS_FREE) return true;
    }
    
    return false;
}

-(void)resetGame{
    for (int i = 0; i < boardWidth; i++)
        for (int j = 0; j < boardHeight; j++)
            board[i][j] = POS_FREE;
}

-(void)deleteLine:(int)y{
    for (int j = y; j > 0; j--)
    {
        for (int i = 0; i < boardWidth; i++)
        {
            board[i][j] = board[i][j-1];
        }
    }
}

-(void)deleteLines{
    for (int j = 0; j < boardHeight; j++)
    {
        int i = 0;
        while (i < boardWidth)
        {
            if (board[i][j] == POS_FREE) break;
            i++;
        }
        
        if (i == boardWidth) [self deleteLine:j];
    }
}

-(BOOL)isBlockFreeAtPoint:(TetrisPoint)point{
    if (board [point.x][point.y] == POS_FREE)
        return true;
    else return false;
}

-(BOOL)isMovementPossible:(TetrisPoint)point piece:(MFTetrisPiece *)piece rotation:(int)rotation{
    for (int i1 = point.x, i2 = 0; i1 < point.x + PIECE_BLOCKS; i1++, i2++)
    {
        for (int j1 = point.y, j2 = 0; j1 < point.y + PIECE_BLOCKS; j1++, j2++)
        {
            // Check if the piece is outside the limits of the board
            if (    i1 < 0           ||
                i1 > boardWidth  - 1    ||
                j1 > boardHeight - 1)
            {
                
                if ([pieces getBlockType:piece.pieceType rotation:rotation x:i2 y:j2] != 0)
                    return NO;
            }
            
            // Check if the piece have collisioned with a block already stored in the map
            if (j1 >= 0)
            {
                TetrisPoint p;
                p.x = i1;
                p.y = j1;
                if ([pieces getBlockType:piece.pieceType rotation:rotation x:i2 y:j2] != 0 &&
                    ![self isBlockFreeAtPoint:p])
                    return NO;
            }
        }
    }
    
    // No collision
    return YES;
}

-(int)blockTypeAtX:(int)x Y:(int)y{
    return board[x][y];
}

-(void)dealloc{
    [pieces release];
    pieces = nil;
    [super dealloc];
}

@end
