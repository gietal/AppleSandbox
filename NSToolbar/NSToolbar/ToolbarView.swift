//
//  ToolbarView.swift
//  NSToolbar
//
//  Created by gietal-dev on 8/16/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa
@IBDesignable class AutoResizingToolbarView: NSView {
    @IBOutlet public var toolbar: NSToolbar?
    @IBOutlet public var mainWindow: NSWindow?
    @IBOutlet public var toolbarItem: NSToolbarItem?
    
    override func awakeFromNib() {
        //mainWindow?.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        mainWindow?.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" && (object as? NSWindow) === mainWindow {
            updateFrame()
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    fileprivate func updateFrame() {
        if let w = mainWindow {
            var size = w.frame.size
            size.height = self.frame.height // keep the height
            self.frame.size = size
            
            toolbarItem?.maxSize = size
            toolbarItem?.minSize = size
        }

    }
}

extension AutoResizingToolbarView: NSWindowDelegate {
    func windowDidResize(_ notification: Notification) {
        updateFrame()
    }
}
