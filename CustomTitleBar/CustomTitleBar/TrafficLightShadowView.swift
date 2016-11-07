//
//  CustomView.swift
//  CustomTitleBar
//
//  Created by Gieta Laksmana on 10/5/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

// implementation taken from office team
class TrafficLightShadowView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        // create black tint
        let shadowColor = NSColor(calibratedWhite: 0.0, alpha: 1.0)
        
        // draw circle of black tint
        if let gc = NSGraphicsContext.current() {
            gc.saveGraphicsState()
            shadowColor.setFill()
            gc.cgContext.fillEllipse(in: NSRectToCGRect(self.bounds))
            gc.restoreGraphicsState()
        }
    }
    
}

