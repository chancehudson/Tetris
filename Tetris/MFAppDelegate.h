//
//  MFAppDelegate.h
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

-(IBAction)createClassicMode:(id)sender;

@end
