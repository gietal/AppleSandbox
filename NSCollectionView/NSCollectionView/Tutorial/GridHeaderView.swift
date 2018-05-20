//
//  GridHeaderView.swift
//  NSCollectionView
//
//  Created by gietal-dev on 5/17/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class GridHeaderView: NSView, NSCollectionViewSectionHeaderView {
    @IBOutlet var sectionCollapseButton: NSButton?
    @IBOutlet weak var sectionTitle: NSTextField!
    
    override func awakeFromNib() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
}
