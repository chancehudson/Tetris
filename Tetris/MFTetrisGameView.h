//
//  MFTetrisGameView.h
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MFView.h"

@class MFTetrisEngine, MFTetrisPiece;

@interface MFTetrisGameView : NSView {
    MFTetrisPiece *currentPiece;
    int holdPieceType;
    BOOL hasSwitchedPiece;
    MFTetrisPiece *ghostPiece;
    
    int score;
    
    CGImageRef brickIImage;
    CGImageRef brickLImage;
    CGImageRef brickReversedLImage;
    CGImageRef brickZImage;
    CGImageRef brickReversedZImage;
    CGImageRef brickTImage;
    CGImageRef brickSquareImage;
    
    NSTimer *gameTimer;
    NSTimer *softDropTimer;
    NSTimer *moveRepeatTimer;
    float currentTimeInterval;
    BOOL locked;
    
    //rendering
    NSTimer *viewTimer;
    NSColor *backgroundColor;
    BOOL rendering;
}

@property (retain) id delegate;

@property (readonly) NSMutableArray *pieceArray;

@property (retain) NSColor *backgroundColor;

@property (readonly) MFTetrisEngine *engine;

-(id)init;
-(void)startGame;

@end
