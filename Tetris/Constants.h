//
//  Constants.h
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#pragma mark Window Sizing

#define WINDOW_SIZE_DEFAULT_WIDTH 360
#define WINDOW_SIZE_DEFAULT_HEIGHT 480
#define WINDOW_SIZE_CLASSIC_WIDTH 300
#define WINDOW_SIZE_CLASSIC_HEIGHT 500

#pragma mark Tetris Constants

#define TETRIS_BOARD_WIDTH 10
#define TETRIS_BOARD_HEIGHT 22
#define TETRIS_MAX_BOARD_WIDTH 500
#define TETRIS_MAX_BOARD_HEIGHT 500
#define TETRIS_BLOCK_SIZE_PIXELS 25

#define TETRIS_NUMBER_OF_PIECES_TO_BUFFER 14 
#define TETRIS_SOFT_DROP_RATE 1.0/20.0
#define TETRIS_MOVE_REPEAT_DELAY 1.0/10.0
#define TETRIS_MOVE_REPEAT_RATE 1.0/20.0

typedef struct TetrisPoint {
    int x;
    int y;
} TetrisPoint;

enum { POS_FILLED_SQUARE = 0, POS_FILLED_I = 1, POS_FILLED_L = 2, POS_FILLED_REVERSE_L = 3, POS_FILLED_Z = 4, POS_FILLED_REVERSE_Z = 5, POS_FILLED_T = 6, POS_FREE = 7 };

@protocol TetrisGameController <NSObject>
@required
-(void)scoreHasChanged:(int)score;
-(void)levelHasChanged:(int)level;
-(void)brickHasBeenPlaced;
-(void)savedBlockHasChanged;

@end