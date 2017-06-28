//
//  ImageView.h
//  CGContextDrawImageScale
//
//  Created by gietal-dev on 6/16/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef ImageView_h
#define ImageView_h

@interface ImageView: NSView

-(void)setImageScale:(CGFloat)scale;
-(void)setChunkSize:(CGSize)size;
@end

#endif /* ImageView_h */
