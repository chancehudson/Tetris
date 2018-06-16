//
//  MFTetrisPiece.m
//  Tetris
//
//  Created by Chance Hudson on 10/31/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import "MFTetrisPiece.h"
#import "MFTetrisPieces.h"

@implementation MFTetrisPiece

@synthesize pieceType = _pieceType;
@synthesize rotation = _rotation;

-(id)initWithType:(int)t rotation:(int)rot{
    if((self = [super init])){
        position = [[MFTetrisPieces sharedPieces] getInitialPosition:t rotation:rot];
        _rotation = rot;
        _pieceType = t;
    }
    return self;
}

-(void)createNewPieceWithType:(int)t rotation:(int)rot{
    position = [[MFTetrisPieces sharedPieces] getInitialPosition:t rotation:rot];
    self.rotation = rot;
    self.pieceType = t;
}

-(TetrisPoint)getPosition{
    return position;
}

-(void)setXPosition:(int)p{
    position.x = p;
}

-(void)setYPosition:(int)p{
    position.y = p;
}

-(void)setPosition:(TetrisPoint)pos{
    position = pos;
}

@end
