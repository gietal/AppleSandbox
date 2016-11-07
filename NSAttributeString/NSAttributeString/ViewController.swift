//
//  ViewController.swift
//  NSAttributeString
//
//  Created by Gieta Laksmana on 8/23/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var textFieldCell: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theString = "For ⌘X, ⌘C, and ⌘V, use the Ctrl Ctrl key instead of [Windows logo key] in remote sessions."

        let currentFont = textFieldCell.font!

        var attribString = NSMutableAttributedString(string: theString, attributes: [NSFontAttributeName: currentFont])

        //attribString.addAttribute(NSFontAttributeName, value: currentFont, range: NSMakeRange(6, 10))
        //attribString.addAttribute(NSFontAttributeName, value: font, range: nsrange)
        attribString.applyFontTrait(.BoldFontMask, onSubstring: "Ctrl")
        attribString.applyFontTrait(.BoldFontMask, onSubstring: "[Windows logo key]")
        textFieldCell.attributedStringValue = attribString
    }
    
    private func addFontTrait(
        to attribString: NSMutableAttributedString,
        onSubstring substring: String,
        trait: NSFontTraitMask
        ) {
        
        let theString = attribString.string
        if let substringRange = theString.rangeOfString(substring) {
            
            let nsrange = NSMakeRange(theString.characters.startIndex.distanceTo(substringRange.startIndex), substringRange.count)
            attribString.applyFontTraits(trait, range: nsrange)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension NSMutableAttributedString {
    
    public func applyFontTrait(traits: NSFontTraitMask, onSubstring substring: String) {
        if let substringRange = string.rangeOfString(substring) {
            let nsrange = NSMakeRange(string.characters.startIndex.distanceTo(substringRange.startIndex), substringRange.count)
            applyFontTraits(traits, range: nsrange)
        }
    }
}

