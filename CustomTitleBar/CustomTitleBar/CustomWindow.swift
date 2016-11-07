//
//  CustomWindow.swift
//  CustomTitleBar
//
//  Created by Gieta Laksmana on 10/11/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

class CustomWindow: NSWindow {
    
    var titleBarView: NSView? {
        return contentView?.superview
    }
    
    var titleBarHeight: CGFloat {
        guard let superFrame = titleBarView?.frame, let frame = contentView?.frame else {
            return 0
        }
        
        return superFrame.height - frame.height
        
    }
    
    public func addViewToTitleBar(view: NSView, atX: CGFloat) {
        guard let contentView = contentView else {
            return
        }
        
        // make frame where the newly added view should be located
        view.frame = NSMakeRect(atX, contentView.frame.height, view.frame.width, titleBarHeight)
        //view.autoresizingMask
        titleBarView?.addSubview(view)
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)
        initCustomTitleBar()
    }
    
    
    
    private func initCustomTitleBar() {
        
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        styleMask.insert(.fullSizeContentView)

        makeTrafficLightConstraint()
    }
    
    func makeTrafficLightConstraint() {
        
        //self.stan
    }
    

}


