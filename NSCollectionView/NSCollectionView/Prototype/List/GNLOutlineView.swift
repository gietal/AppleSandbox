//
//  GNLOutlineView.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 7/22/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa
class GNLOutlineView: NSOutlineView {
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        
        // customize disclosure button
        if identifier == NSOutlineView.disclosureButtonIdentifier {
            
            // first, get the original button
            let originalButton = super.makeView(withIdentifier: identifier, owner: owner) as! NSButton
            
            // then create our custom button
            let myView = super.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyDisclosureButton"), owner: owner) as! NSButton
            // we need to change our custom button's identifier to be NSOutlineViewDisclosureButtonKey
            // so the outlineView can reuse the button, otherwise it will recreate it everytime
            myView.identifier = identifier
            
            // then we need to transfer the target/action selector from the original button
            // because the original button's action is pointed to a private method "_outlineControlClicked"
            myView.target = originalButton.target
            myView.action = originalButton.action
            
            return myView
        }
        
        // for everything else, use the default function
        return super.makeView(withIdentifier: identifier, owner: owner)
        
    }
}
