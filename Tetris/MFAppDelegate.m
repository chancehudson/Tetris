//
//  MFAppDelegate.m
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import "MFAppDelegate.h"
#import "Constants.h"
#import "MFTetrisGameView.h"
#import "MFSprite.h"

@implementation MFAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self createClassicMode:nil];
}

-(IBAction)createClassicMode:(id)sender{
    NSRect windowRect;
    windowRect.origin = _window.frame.origin;
    windowRect.size.width = TETRIS_BOARD_WIDTH*TETRIS_BLOCK_SIZE_PIXELS;
    windowRect.size.height = TETRIS_BOARD_HEIGHT*TETRIS_BLOCK_SIZE_PIXELS+20;
    CGPoint centerPoint = CGPointMake(_window.frame.origin.x+(_window.frame.size.width/2.f), _window.frame.origin.y+(_window.frame.size.height/2.f));
    windowRect.origin.x = centerPoint.x-(windowRect.size.width/2.f);
    windowRect.origin.y = centerPoint.y-(windowRect.size.height/2.f);
    [_window setFrame:windowRect display:YES animate:NO];
	
	MFTetrisGameView *view = [[MFTetrisGameView alloc] init];
	[view setFrame:NSRectFromCGRect(CGRectMake(0, 0, windowRect.size.width, windowRect.size.height))];
	[_window.contentView addSubview:view];
    [view startGame];
	[view release];
}

@end
