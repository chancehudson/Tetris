//
//  MFView.h
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class MFSprite;

@interface MFView : NSView {
	NSMutableArray *sprites;
	NSTimer *timer;
	BOOL rendering;
}

@property (atomic, retain) NSMutableArray *sprites;
@property (atomic, retain) NSColor *backgroundColor;

-(void)startRendering;
-(void)stopRendering;

-(void)addSprite:(MFSprite*)sprite;
-(void)spriteWillBeDestroyed:(MFSprite*)sprite;

@end
