//
//  Sheet.swift
//  OpaqueSheet
//
//  Created by gietal-dev on 1/22/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class SheetView: NSView {
    override func viewDidMoveToSuperview() {
        guard let siblings = superview?.subviews else {
            return
        }
        
        // this will get the visual effect view added by Appkit
        guard let vfxView = siblings.first(where: { $0 is NSVisualEffectView }) as? NSVisualEffectView else {
            return
        }
        
        // this will make it so that the visual effect view stops blending
        // its content with the beckground
        vfxView.blendingMode = .withinWindow
    }
    
    override func viewDidMoveToWindow() {
        guard let siblings = superview?.subviews else {
            return
        }
        
        // this will get the visual effect view added by Appkit
        guard let vfxView = siblings.first(where: { $0 is NSVisualEffectView }) as? NSVisualEffectView else {
            return
        }
        
        // this will make it so that the visual effect view stops blending
        // its content with the beckground
        vfxView.blendingMode = .withinWindow
    }
    
    
}

class SheetViewController: NSViewController {
    convenience init() {
        self.init(nibName: NSNib.Name(stringLiteral: "Sheet"), bundle: nil)
    }
    @IBAction func closeSheet(_ sender: Any) {
        if let win = view.window {
            win.sheetParent?.endSheet(win)
        }
    }
    
    override func viewWillAppear() {
        // by default Appkit automatically adds an NSVisualEffectView
        // behind our sheet view
        // the structure of the sheet window then become this:
        // window
        // |- theme frame view
        //    |- NSVisualEffectView
        //    |- our view
        //    |- other views that Appkit could possibly add
        
        // this will get all the views under the theme frame view
        guard let siblings = view.superview?.subviews else {
            return
        }
        
        // this will get the visual effect view added by Appkit
        guard let vfxView = siblings.first(where: { $0 is NSVisualEffectView }) as? NSVisualEffectView else {
            return
        }
        
        // this will make it so that the visual effect view stops blending
        // its content with the beckground
//        vfxView.blendingMode = .withinWindow
    }

}
