//
//  ImageView.m
//  CGContextDrawImageScale
//
//  Created by gietal-dev on 6/16/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageView.h"
#import <math.h>

@implementation ImageView {
    CGImageRef originalImage;
    CGRect remoteFullFrame;
    CGRect localFullFrame;
    CGSize chunkSize;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    // load image
    originalImage = [[NSImage imageNamed:@"buffer123"] CGImageForProposedRect:nil context:nil hints:nil];
    remoteFullFrame.origin = CGPointMake(0, 0);
    remoteFullFrame.size = CGSizeMake(CGImageGetWidth(originalImage), CGImageGetHeight(originalImage));
    CGFloat scale = 1.666;
    
    [self setImageScale:scale];
    [self setChunkSize:CGSizeMake(97, 720 * scale)];
    [self setFrameSize:localFullFrame.size];
}

-(void)setImageScale:(CGFloat)scale {
    localFullFrame = remoteFullFrame;
    localFullFrame.size.width *= scale;
    localFullFrame.size.height *= scale;
    
    [self setNeedsDisplay:YES];
}

-(void)setChunkSize:(CGSize)size {
    chunkSize = size;
    
    [self setNeedsDisplay:YES];
}

-(CGRect)remoteToLocal:(CGRect)remoteRect {
    CGRect output = remoteRect;
    
    CGFloat scalex = localFullFrame.size.width / remoteFullFrame.size.width;
    CGFloat scaley = localFullFrame.size.height / remoteFullFrame.size.height;
    
    output.origin.x *= scalex;
    output.origin.y *= scaley;
    output.size.width *= scalex;
    output.size.height *= scaley;
    
    return [self roundRect:output];
}

-(CGRect)localToRemote:(CGRect)localRect {
    CGRect output = localRect;
    
    CGFloat scalex = remoteFullFrame.size.width / localFullFrame.size.width;
    CGFloat scaley = remoteFullFrame.size.height / localFullFrame.size.height;
    
    output.origin.x *= scalex;
    output.origin.y *= scaley;
    output.size.width *= scalex;
    output.size.height *= scaley;
    
    return output;
}

-(void)drawLine:(CGContextRef)context :(CGPoint)startPoint :(CGPoint)endPoint :(CGColorRef)color {
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y );
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)drawLineAtRightOfRect:(CGContextRef)context :(CGRect)rect {
    CGFloat x = rect.origin.x + rect.size.width;
    CGPoint start = CGPointMake(x, rect.origin.y);
    CGPoint end = CGPointMake(x, rect.origin.y +  rect.size.height);
    [self drawLine:context :start :end :CGColorCreateGenericRGB(1, 0, 0, 1)];
}

-(void)drawLineAroundRect:(CGContextRef)context :(CGRect)rect {
    CGColorRef color = CGColorCreateGenericRGB(1, 0, 0, .2);
    
    CGPoint bottomLeft = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);

    [self drawLine:context :bottomLeft :bottomRight :color];
    [self drawLine:context :bottomRight :topRight :color];
    [self drawLine:context :topRight :topLeft :color];
    [self drawLine:context :topLeft :bottomLeft :color];
}

-(CGRect)roundRect:(CGRect)rect {
    rect.origin.x = floor(rect.origin.x);
    rect.origin.y = floor(rect.origin.y);
    rect.size.width = floor(rect.size.width);
    rect.size.height = floor(rect.size.height);
    return rect;
}

-(CGImageRef)getRemoteImage:(CGRect)rect {
    rect = [self roundRect:rect];
    rect.origin.y = remoteFullFrame.size.height - (rect.origin.y + rect.size.height);
    return CGImageCreateWithImageInRect(originalImage, rect);
}

-(void)drawRect:(NSRect)dirtyRect {
    CGContextRef context = (CGContextRef)[NSGraphicsContext currentContext].graphicsPort;
    if (!context) {
        return;
    }
    [self setFrameSize:localFullFrame.size];
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    // draw full
    CGContextSaveGState(context);
    CGRect remoteDirtyRect = remoteFullFrame;
    CGRect localDirtyRect = [self remoteToLocal:remoteDirtyRect];
    CGContextClipToRect(context, localDirtyRect);
    CGContextDrawImage(context, localDirtyRect, originalImage);
    CGContextRestoreGState(context);
    
    // draw  chunks
    for(CGFloat y = 0.0f; y <= remoteFullFrame.size.height; y += chunkSize.height) {
        for(CGFloat x = 0.0f; x <= remoteFullFrame.size.width; x += chunkSize.width) {
            CGContextSaveGState(context);
            CGRect remoteChunk = CGRectMake(x, y, chunkSize.width, chunkSize.height);
            CGRect localChunk = [self remoteToLocal:remoteChunk];
            CGRect remoteChunk2 = [self localToRemote:localChunk];
            CGImageRef chunkImage = [self getRemoteImage:remoteChunk2];
            CGContextDrawImage(context, localChunk, chunkImage);
            //        [self drawLineAtRightOfRect:context :localChunk];
            [self drawLineAroundRect:context :localChunk];

            CGContextRestoreGState(context);
        }
    }

    
    CGContextRestoreGState(context);
}

@end
