//
//  MFTetrisPiece.h
//  Tetris
//
//  Created by Chance Hudson on 10/31/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MFTetrisPiece : NSObject {
    TetrisPoint position;
    int pieceType;
    int rotation;
}

@property (nonatomic, assign)int pieceType;
@property (nonatomic, assign)int rotation;

-(id)initWithType:(int)t rotation:(int)rot;
-(TetrisPoint)getPosition;
-(void)setXPosition:(int)p;
-(void)setYPosition:(int)p;
-(void)setPosition:(TetrisPoint)pos;
-(void)createNewPieceWithType:(int)t rotation:(int)rot;

@end
