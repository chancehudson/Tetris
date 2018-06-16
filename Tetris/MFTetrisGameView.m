//
//  MFTetrisGameView.m
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import "MFTetrisGameView.h"
#import "MFTetrisEngine.h"
#import "MFTetrisPiece.h"
#import "MFTetrisPieces.h"

@implementation MFTetrisGameView

@synthesize engine = _engine;
@synthesize backgroundColor = _backgroundColor;
@synthesize pieceArray = _pieceArray;
@synthesize delegate = _delegate;

-(id)initWithFrame:(NSRect)frameRect{
	if((self = [super initWithFrame:frameRect])){
        
	}
	return self;
}

-(id)init{
    if((self = [super init])){
        self.frame = NSRectFromCGRect(CGRectMake(0, 0, TETRIS_BOARD_WIDTH*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BOARD_HEIGHT*TETRIS_BLOCK_SIZE_PIXELS));
        brickIImage = CGImageCreateWithNSImage([NSImage imageNamed:@"brickIImage.png"]);
        self.backgroundColor = [NSColor grayColor];
        _engine = [[MFTetrisEngine alloc] initGameWithPieces:[MFTetrisPieces sharedPieces]];
        _pieceArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark Game

-(void)startGame{
    [_pieceArray removeAllObjects];
    [self updatePieceArray];
    int x = [[_pieceArray objectAtIndex:0] intValue];
	currentPiece = [[MFTetrisPiece alloc] initWithType:x rotation:3];
    ghostPiece = [[MFTetrisPiece alloc] initWithType:currentPiece.pieceType rotation:currentPiece.rotation];
    [_pieceArray removeObjectAtIndex:0];
    [self updateGhostPiece];
    currentTimeInterval = 1.2;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:currentTimeInterval target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
    score = 0;
    [self.delegate scoreHasChanged:score];
}

-(void)createNewPiece{
    int x = [[_pieceArray objectAtIndex:0] intValue];
    [currentPiece createNewPieceWithType:x rotation:3];
    [ghostPiece createNewPieceWithType:currentPiece.pieceType rotation:currentPiece.rotation];
    [self updateGhostPiece];
    [_pieceArray removeObjectAtIndex:0];
    [self updatePieceArray];
    currentTimeInterval -= 0.001;
    [gameTimer invalidate];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:currentTimeInterval target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
    hasSwitchedPiece = NO;
    if(_engine.isGameOver){
        [_engine resetGame];
        [self resetGame];
    }
    [self display];
}

-(void)updatePieceArray{
    while (_pieceArray.count < TETRIS_NUMBER_OF_PIECES_TO_BUFFER) {
        NSMutableArray *newPieces = [NSMutableArray array];
        NSMutableIndexSet *usedIndexes = [NSMutableIndexSet indexSet];
        for(int x = 0; x < 7; x++){
            int y = arc4random()%7;
            while([usedIndexes containsIndex:y]){
                y = arc4random()%7;
            }
            [newPieces addObject:[NSNumber numberWithInt:y]];
            [usedIndexes addIndex:y];
        }
        [_pieceArray addObjectsFromArray:newPieces];
        [newPieces removeAllObjects];
        [usedIndexes removeAllIndexes];
    }
}

-(void)resetGame{
    int x = (arc4random()%7);
    [currentPiece createNewPieceWithType:x rotation:3];
    [ghostPiece createNewPieceWithType:currentPiece.pieceType rotation:currentPiece.rotation];
    [self updateGhostPiece];
    currentTimeInterval = 1.2;
    [gameTimer invalidate];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:currentTimeInterval target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
    hasSwitchedPiece = NO;
    [self display];
}

-(void)updateGame{
    if([self.engine isMovementPossible:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+1} piece:currentPiece rotation:currentPiece.rotation]){
        [currentPiece setPosition:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+1}];
    }
    else{
        [self.engine storePiece:currentPiece];
        [self.engine deleteLines];
        [self createNewPiece];
    }
    [gameTimer invalidate];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:currentTimeInterval target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
    [self display];
}

-(void)updateGhostPiece{
    int x = 0;
    [ghostPiece setPosition:currentPiece.getPosition];
    while ([self.engine isMovementPossible:(TetrisPoint){ghostPiece.getPosition.x, ghostPiece.getPosition.y+x} piece:ghostPiece rotation:ghostPiece.rotation]){
        x++;
    }
    x-=1;
    if([self.engine isMovementPossible:(TetrisPoint){ghostPiece.getPosition.x, ghostPiece.getPosition.y+x} piece:ghostPiece rotation:ghostPiece.rotation]){
        [ghostPiece setPosition:(TetrisPoint){ghostPiece.getPosition.x, ghostPiece.getPosition.y+x}];
    }
}

#pragma mark User Controls

-(void)hardDropCurrentPiece{
    int x = 0;
    while ([self.engine isMovementPossible:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+x} piece:currentPiece rotation:currentPiece.rotation]){
        x++;
    }
    x-=1;
    if([self.engine isMovementPossible:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+x} piece:currentPiece rotation:currentPiece.rotation]){
        [currentPiece setPosition:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+x}];
    }
    [self.engine storePiece:currentPiece];
    [self.engine deleteLines];
    [self createNewPiece];
}

-(void)moveCurrentPieceDown{
    if([_engine isMovementPossible:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+1} piece:currentPiece rotation:currentPiece.rotation]){
        [currentPiece setPosition:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y+1}];
    }
    [self display];
}

-(void)rotateCurrentPiece{
    if([_engine isMovementPossible:(TetrisPoint){currentPiece.getPosition.x, currentPiece.getPosition.y} piece:currentPiece rotation:(currentPiece.rotation+1>3)?0:(currentPiece.rotation+1)]){
        [currentPiece setRotation:(currentPiece.rotation-1<0)?3:(currentPiece.rotation-1)];
        [ghostPiece setRotation:currentPiece.rotation];
        [self updateGhostPiece];
    }
    [self display];
}

-(void)moveCurrentPiece:(BOOL)left{
    if([_engine isMovementPossible:(TetrisPoint){currentPiece.getPosition.x+(left?-1:1), currentPiece.getPosition.y} piece:currentPiece rotation:currentPiece.rotation]){
        [currentPiece setPosition:(TetrisPoint){currentPiece.getPosition.x+(left?-1:1), currentPiece.getPosition.y}];
    }
    [self updateGhostPiece];
    [self display];
}

-(void)moveCurrentPieceCallback:(NSTimer*)t{
    [self moveCurrentPiece:[t.userInfo boolValue]];
}

-(void)holdPiece{
    if(holdPieceType == -1){
        holdPieceType = currentPiece.pieceType;
        [self createNewPiece];
    }
    else if(!hasSwitchedPiece){
        int h = holdPieceType;
        holdPieceType = currentPiece.pieceType;
        hasSwitchedPiece = YES;
        [currentPiece createNewPieceWithType:h rotation:3];
        [ghostPiece createNewPieceWithType:currentPiece.pieceType rotation:currentPiece.rotation];
        [self updateGhostPiece];
    }
    [self display];
}

-(BOOL)acceptsFirstResponder{
    return YES;
}

-(void)beginMovingFast:(NSTimer*)left{
    NSNumber *n = left.userInfo;
    [moveRepeatTimer invalidate];
    moveRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:TETRIS_SOFT_DROP_RATE target:self selector:@selector(moveCurrentPieceCallback:) userInfo:n repeats:YES];
}

-(void)keyDown:(NSEvent *)theEvent{
    if(theEvent.isARepeat)
        return;
    switch( [theEvent keyCode] ) {
        case 126:[self rotateCurrentPiece]; break;
        case 125:{
            if(!softDropTimer)
                softDropTimer = [NSTimer scheduledTimerWithTimeInterval:TETRIS_MOVE_REPEAT_RATE target:self selector:@selector(updateGame) userInfo:nil repeats:YES];
            break;
        }// down arrow
        case 124:{
            [moveRepeatTimer invalidate];
            moveRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:TETRIS_MOVE_REPEAT_DELAY target:self selector:@selector(beginMovingFast:) userInfo:[NSNumber numberWithBool:NO] repeats:YES];
            [self moveCurrentPiece:NO];
            break;
            
        }// right arrow
        case 123:{
            [moveRepeatTimer invalidate];
            moveRepeatTimer = [NSTimer scheduledTimerWithTimeInterval:TETRIS_MOVE_REPEAT_DELAY target:self selector:@selector(beginMovingFast:) userInfo:[NSNumber numberWithBool:YES] repeats:YES];
            [self moveCurrentPiece:YES];
            break;
        }      // left arrow
        case 49: [self hardDropCurrentPiece]; break;
    }
}

-(void)keyUp:(NSEvent *)theEvent{
    switch( [theEvent keyCode] ) {
        case 126:break;
        case 125:{
            [softDropTimer invalidate];
            softDropTimer = nil;
            break;
        }// down arrow
        case 124:{
            if(![moveRepeatTimer.userInfo boolValue]){
                [moveRepeatTimer invalidate];
                moveRepeatTimer = nil;
            }
            break;
        }       // right arrow
        case 123:{
            if([moveRepeatTimer.userInfo boolValue]){
                [moveRepeatTimer invalidate];
                moveRepeatTimer = nil;
            }
            break;
        }// left arrow
        case 49:break;
    }
}

-(void)flagsChanged:(NSEvent *)theEvent{
    if ([theEvent modifierFlags] & NSShiftKeyMask) {
        [self holdPiece];
    }
}

#pragma mark View Rendering

-(void)startRendering{
	if(rendering){
		[self stopRendering];
	}
	rendering = YES;
	viewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(display) userInfo:nil repeats:YES];
}

-(void)stopRendering{
	[viewTimer invalidate];
	viewTimer = nil;
	rendering = NO;
}

-(void)drawRect:(NSRect)bounds{
	[self lockFocus];
	CGContextRef context = [NSGraphicsContext currentContext].graphicsPort;
    CGContextClearRect(context, bounds);
    CGAffineTransform flipVertical = CGAffineTransformMake(
                                                           1, 0, 0, -1, 0, bounds.size.height
                                                           );
    CGContextConcatCTM(context, flipVertical);
	if(_backgroundColor){
		CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
		CGContextFillRect(context, bounds);
	}
    
    CGContextSetStrokeColorWithColor(context, [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.5].CGColor);
    
    //draw game board
    for(int x = 0; x < TETRIS_BOARD_WIDTH; x++){
        for(int y = 0; y < TETRIS_BOARD_HEIGHT; y++){
            if([_engine blockTypeAtX:x Y:y] != 7){
                switch ([_engine blockTypeAtX:x Y:y]) {
                    case 0:
                        CGContextSetFillColorWithColor(context, [NSColor yellowColor].CGColor);
                        break;
                    case 1:
                        CGContextSetFillColorWithColor(context, [NSColor blueColor].CGColor);
                        break;
                    case 2:
                        CGContextSetFillColorWithColor(context, [NSColor orangeColor].CGColor);
                        break;
                    case 3:
                        CGContextSetFillColorWithColor(context, [NSColor blueColor].CGColor);
                        break;
                    case 4:
                        CGContextSetFillColorWithColor(context, [NSColor redColor].CGColor);
                        break;
                    case 5:
                        CGContextSetFillColorWithColor(context, [NSColor greenColor].CGColor);
                        break;
                    case 6:
                        CGContextSetFillColorWithColor(context, [NSColor purpleColor].CGColor);
                        break;
                }
                CGContextFillRect(context, CGRectMake(x*TETRIS_BLOCK_SIZE_PIXELS, y*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS));
                CGContextStrokeRect(context, CGRectMake(x*TETRIS_BLOCK_SIZE_PIXELS, y*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS));
            }
        }
    }
    
    //draw ghost piece
    if(ghostPiece){
        for (int x = 0; x < 5; x++) {
            for(int y = 0; y < 5; y++){
                if([[MFTetrisPieces sharedPieces] getBlockType:ghostPiece.pieceType rotation:ghostPiece.rotation x:x y:y]){
                    CGContextSetFillColorWithColor(context, [NSColor colorWithSRGBRed:1 green:1 blue:1 alpha:0.5].CGColor);
                    CGContextFillRect(context, CGRectMake((x+[ghostPiece getPosition].x)*TETRIS_BLOCK_SIZE_PIXELS, (y+[ghostPiece getPosition].y)*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS));
                    CGContextStrokeRect(context, CGRectMake((x+[ghostPiece getPosition].x)*TETRIS_BLOCK_SIZE_PIXELS, (y+[ghostPiece getPosition].y)*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS));
                }
            }
        }
    }
    
    //draw current piece
    if(currentPiece){
        for (int x = 0; x < 5; x++) {
            for(int y = 0; y < 5; y++){
                if([[MFTetrisPieces sharedPieces] getBlockType:currentPiece.pieceType rotation:currentPiece.rotation x:x y:y]){
                    switch ([[MFTetrisPieces sharedPieces] getBlockType:currentPiece.pieceType rotation:currentPiece.rotation x:x y:y]-1) {
                        case 0:
                            CGContextSetFillColorWithColor(context, [NSColor yellowColor].CGColor);
                            break;
                        case 1:
                            CGContextSetFillColorWithColor(context, [NSColor blueColor].CGColor);
                            break;
                        case 2:
                            CGContextSetFillColorWithColor(context, [NSColor orangeColor].CGColor);
                            break;
                        case 3:
                            CGContextSetFillColorWithColor(context, [NSColor blueColor].CGColor);
                            break;
                        case 4:
                            CGContextSetFillColorWithColor(context, [NSColor redColor].CGColor);
                            break;
                        case 5:
                            CGContextSetFillColorWithColor(context, [NSColor greenColor].CGColor);
                            break;
                        case 6:
                            CGContextSetFillColorWithColor(context, [NSColor purpleColor].CGColor);
                            break;
                    }
                    CGContextFillRect(context, CGRectMake((x+[currentPiece getPosition].x)*TETRIS_BLOCK_SIZE_PIXELS, (y+[currentPiece getPosition].y)*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS));
                    CGContextStrokeRect(context, CGRectMake((x+[currentPiece getPosition].x)*TETRIS_BLOCK_SIZE_PIXELS, (y+[currentPiece getPosition].y)*TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS, TETRIS_BLOCK_SIZE_PIXELS));
                }
            }
        }
    }
    
	[self unlockFocus];
}

CGImageRef CGImageCreateWithNSImage(NSImage *image) {
    NSSize imageSize = [image size];
	
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
	
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
    [image drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
	
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    return cgImage;
}

-(void)dealloc{
    [gameTimer invalidate];
    [softDropTimer invalidate];
    [moveRepeatTimer invalidate];
    [self stopRendering];
    [super dealloc];
}

@end
