//
//  XibView.swift
//  NSToolbar
//
//  Created by gietal-dev on 8/16/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa
// https://medium.com/zenchef-tech-and-product/how-to-visualize-reusable-xibs-in-storyboards-using-ibdesignable-c0488c7f525d

protocol XibViewDelegate {
    func onXibSetupDone()
}

@IBDesignable class XibView: NSView {
    var contentView: NSView?
    @IBInspectable var nibName: String?
    @IBInspectable var delegate: XibViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = bounds
        view.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
        addSubview(view)
        contentView = view
        needsDisplay = true
        delegate?.onXibSetupDone()
    }
    
    func loadViewFromNib() -> NSView? {
        let bundle = Bundle(for: type(of: self))
        guard let nib = NSNib(nibNamed: "emptyView", bundle: bundle) else {
            return nil
        }
        
        var objects = NSArray()
        if nib.instantiate(withOwner: nil, topLevelObjects: &objects) {
            for o in objects {
                if let view = o as? NSView {
                    return view
                }
            }
        }
        return nil
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
}
