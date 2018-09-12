//
//  MyView.swift
//  mouseEvent
//
//  Created by gietal-dev on 22/08/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class MyView: NSView {
    override func mouseDown(with event: NSEvent) {
        print("MyView: mouse down")
    }
    
    override func mouseUp(with event: NSEvent) {
        print("MyView: mouse up")
    }
    
    override func mouseDragged(with event: NSEvent) {
        print("MyView: mouse dragged")
    }
}
