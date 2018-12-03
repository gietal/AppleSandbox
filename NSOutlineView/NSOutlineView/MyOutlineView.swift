//
//  MyOutlineView.swift
//  NSOutlineView
//
//  Created by gietal-dev on 18/10/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import Cocoa


class MyOutlineView: NSOutlineView {
    override func awakeFromNib() {
        // setup the column to use our header cell
        for c in self.tableColumns {
            let header = MyTableHeaderCell(textCell: c.headerCell.stringValue)
            c.headerCell = header
        }
    }
    
    
}

extension NSFont {
    
}

class MyTableHeaderCell: NSTableHeaderCell {
    deinit {
        print("table header deinit")
    }
    let customFont: NSFont = NSFont.systemFont(ofSize: 20) // setting the custom font to use on the
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
//        let customFont = outlineView!.customFont
//        print("font descriptor matrix: \(customFont.fontDescriptor.matrix)")
//        print("matrix: \(customFont.matrix)")
        
        
        // these parts are using NSFont's private API, which I understand is not standard
        // but every crash report I get points to the fact that _sharedFontInstanceInfo is nil SOMETIMES on:
        // - macmini6,2 with Mac OS X 10.12.6 (16G1510)
        // - macpro5,1 with Mac OS X 10.13.6 (17G65)
        // - imac17,1 with Mac OS X 10.13.4 (17E199)
        //
        // I would like to understand why, and whether I use the api incorrectly,
        // I would also like a solution to change the font on the table header cell, because I can't change it from the xib designer
        print("attempting to get _sharedFontInstanceInfo")
        var sel = Selector(("_sharedFontInstanceInfo"))
        guard let fontInstanceInfo = customFont.perform(sel) else {
            print("_sharedFontInstanceInfo is nil")
//            super.drawInterior(withFrame: cellFrame, in: controlView)
            return
        }
        print("_sharedFontInstanceInfo is valid")

        print("attempting to get _platformFont")
        sel = Selector(("_platformFont"))
        guard let platformFont = fontInstanceInfo.takeUnretainedValue().perform(sel) else {
            print("_platformFont is nil")
//            super.drawInterior(withFrame: cellFrame, in: controlView)
            return
        }
        print("_platformFont is valid")
        
        var mutable = NSMutableAttributedString(attributedString: attributedStringValue)
        mutable.removeAttribute(.font, range: NSRange(location: 0, length: mutable.length))
        mutable.addAttribute(.font, value: customFont, range: NSRange(location: 0, length: mutable.length))
//        attributedStringValue = mutable
        
        // need to recreate attributed string here, since the super class seems to recreate
        // the attributes with a standard system font 11 and color
//        attributedStringValue = NSAttributedString(string: stringValue, attributes: [
//            .font: customFont,
//            .foregroundColor: NSColor.headerTextColor
//            ])

        // offset the drawing rect so the text is not exactly on the left edge
        super.drawInterior(withFrame: cellFrame, in: controlView)
    }
}
