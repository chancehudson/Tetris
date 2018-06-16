//
//  MFView.m
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import "MFView.h"
#import "MFSprite.h"

@implementation MFView

@synthesize sprites = _sprites;
@synthesize backgroundColor = _backgroundColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_sprites = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark View Rendering

-(void)startRendering{
	if(rendering){
		[self stopRendering];
	}
	rendering = YES;
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(display) userInfo:nil repeats:YES];
}

-(void)stopRendering{
	[timer invalidate];
	timer = nil;
	rendering = NO;
}

-(void)drawRect:(NSRect)bounds{
	[self lockFocus];
	CGContextRef context = [NSGraphicsContext currentContext].graphicsPort;
	if(_backgroundColor){
    
//        CGFloat components[4] = {
//            arc4random() % 255 / 255.0,
//            arc4random() % 255 / 255.0,
//            arc4random() % 255 / 255.0,
//            1.0
//        };
//        NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace]
//                                           components:components
//                                                count:4];
		CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
//        CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, bounds);
	}
	for(MFSprite *s in self.sprites){
		CGContextDrawImage(context, s.frame, s.image);
	}
	[self unlockFocus];
}

#pragma mark Handling Sprites

-(void)addSprite:(MFSprite*)sprite{
	[self.sprites addObject:sprite];
	[sprite setSuperview:self];
}

-(void)spriteWillBeDestroyed:(MFSprite*)sprite{
	[self.sprites removeObject:sprite];
}

@end
