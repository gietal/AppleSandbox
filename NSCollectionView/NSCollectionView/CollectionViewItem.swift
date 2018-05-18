//
//  CollectionViewItem.swift
//  NSCollectionView
//
//  Created by gietal-dev on 5/16/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    // 1
    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else {
                return
                
            }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
            view.needsDisplay = true
        }
    }
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5 : 0
        }
    }
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.borderColor = NSColor.white.cgColor
        view.layer?.borderWidth = 0
    }
}
