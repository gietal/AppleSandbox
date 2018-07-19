//
//  PopoverPrivate.m
//  MenuBarApp
//
//  Created by Gieta Laksmana on 6/6/18.
//  Copyright © 2018 gietal. All rights reserved.
//

#import "PopoverPrivate.h"

@interface NSWindow (PrivateAppKitThings)
- (void)_setAlwaysOnTop:(BOOL)flag;
@end

@implementation NSPopover (PrivateAppKitThings)

- (void)setAllowedOnAllSpaces {
    NSWindow *window = self.contentViewController.view.window;
    if ([window respondsToSelector:@selector(_setAlwaysOnTop:)]) {
        [window _setAlwaysOnTop:YES];
        [window setCollectionBehavior:[window collectionBehavior]|NSWindowCollectionBehaviorFullScreenAuxiliary];
    }
}

@end
