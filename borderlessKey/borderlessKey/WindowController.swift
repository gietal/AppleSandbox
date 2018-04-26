//
//  WindowController.swift
//  borderlessKey
//
//  Created by gietal-dev on 9/25/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class BorderlessWindowController: NSWindowController, NSWindowDelegate {
    
    static var count = 0
    
    var windowId = 0
    override func windowDidLoad() {
        super.windowDidLoad()
        windowId = BorderlessWindowController.count
        BorderlessWindowController.count += 1
        window?.delegate = self
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        print("did become key: \(windowId)")
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        //print("did become main: \(windowId)")
    }
}

class BorderlessWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}
