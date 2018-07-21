//
//  PopoverPrivate.h
//  MenuBarApp
//
//  Created by Gieta Laksmana on 6/6/18.
//  Copyright © 2018 gietal. All rights reserved.
//

open radar about NSPopoverWindow not showing when other app is fullscreened
hamlin@apple.com
Mark Hamlin

#import <Cocoa/Cocoa.h>

@interface NSPopover (PrivateAppKitThings)

- (void)setAllowedOnAllSpaces;

@end


