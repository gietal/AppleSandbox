//
//  ColorView.swift
//  CustomTitleBar
//
//  Created by Gieta Laksmana on 10/17/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

@IBDesignable open class ColorView: NSView {
    
    // MARK: Public Properties
    
    /// The color to fill the view with.
    @IBInspectable open var color: NSColor = NSColor.white
    
    // MARK: NSView Overrides
    
    override open func draw(_ dirtyRect: NSRect) {
        color.setFill()
        NSRectFill(dirtyRect)
    }
}
