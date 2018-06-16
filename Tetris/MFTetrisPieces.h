//
//  MFTetrisPiece.h
//  Tetris
//
//  Created by Chance Hudson on 10/31/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MFTetrisPieces : NSObject

-(int)getBlockType:(int)pieceType rotation:(int)rot x:(int)x y:(int)y;
-(TetrisPoint)getInitialPosition:(int)pieceType rotation:(int)rot;

+(MFTetrisPieces*)sharedPieces;

@end
