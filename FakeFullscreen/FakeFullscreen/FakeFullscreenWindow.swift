//
//  FakeFullscreenWindow.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class FakeFullscreenWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override func performDrag(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func toggleFullScreen(_ sender: Any?) {
        if let wc = windowController as? FakeFullscreenWindowController {
            if wc.isFullscreen() {
                wc.goWindowed(self)
            } else {
                wc.goFullscreen(self)
            }
        }
    }
}
