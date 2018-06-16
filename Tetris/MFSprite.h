//
//  MFSprite.h
//  Tetris
//
//  Created by Chance Hudson on 10/30/12.
//  Copyright (c) 2012 Chance Hudson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFSprite : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGImageRef image;
@property (nonatomic, retain) id superview;

-(id)initWithNSImage:(NSImage*)i frame:(CGRect)f;
-(id)initWithImage:(CGImageRef)i frame:(CGRect)f;

-(void)setSuperview:(id)superview;
-(void)removeFromSuperview;

@end

@protocol MFSpriteSuperview <NSObject>
@required
-(void)spriteWillBeDestroyed:(MFSprite*)sprite;

@end