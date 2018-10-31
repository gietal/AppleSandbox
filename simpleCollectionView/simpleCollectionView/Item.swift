//
//  Item.swift
//  simpleCollectionView
//
//  Created by gietal-dev on 11/10/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import AppKit

class Item: NSCollectionViewItem {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.borderColor = NSColor.black.cgColor
        
        view.needsDisplay = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                view.layer?.borderColor = NSColor.alternateSelectedControlColor.cgColor
            } else {
                view.layer?.borderColor = NSColor.black.cgColor
            }
            
            view.needsDisplay = true
        }
    }
}
