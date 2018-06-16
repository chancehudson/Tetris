//
//  MFSprite.m
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import "MFSprite.h"

@implementation MFSprite

@synthesize image, frame;
@synthesize superview = _superview;

-(id)initWithNSImage:(NSImage*)i frame:(CGRect)f{
	if((self = [super init])){
		self.frame = f;
//		self.image = CGImageCreateWithNSImage(i);
	}
	return self;
}

-(id)initWithImage:(CGImageRef)i frame:(CGRect)f{
	if((self = [super init])){
		self.frame = f;
		self.image = i;
	}
	return self;
}

//CGImageRef CGImageCreateWithNSImage(NSImage *image) {
//    NSSize imageSize = [image size];
//	
//    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
//	
//    [NSGraphicsContext saveGraphicsState];
//    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
//    [image drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
//    [NSGraphicsContext restoreGraphicsState];
//	
//    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
//    CGContextRelease(bitmapContext);
//    return cgImage;
//}

#pragma mark Superview handling

-(void)removeFromSuperview{
	[self.superview spriteWillBeDestroyed:self];
	self.superview = nil;
}

-(void)dealloc{
	[self.superview spriteWillBeDestroyed:self];
	self.image = nil;
	[super dealloc];
}

@end
