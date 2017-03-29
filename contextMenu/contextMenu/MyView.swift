//
//  View.swift
//  contextMenu
//
//  Created by Gieta Laksmana on 1/11/17.
//  Copyright © 2017 gietal. All rights reserved.
//

import Foundation
import Cocoa

class MyView: NSView {
    
    override func rightMouseUp(with event: NSEvent) {
        Swift.print("right mouse up")
        super.rightMouseUp(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        Swift.print("mouse up")
        super.mouseUp(with: event)
    }
    
    override func otherMouseUp(with event: NSEvent) {
        Swift.print("other mouse up")
        super.otherMouseUp(with: event)
    }
}
