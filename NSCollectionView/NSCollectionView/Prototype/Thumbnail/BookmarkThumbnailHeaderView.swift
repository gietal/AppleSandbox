//
//  BookmarkThumbnailHeaderView.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/19/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

protocol BookmarkThumbnailHeaderViewDelegate: class {
    func onCollapseButtonPressed(forGroup group: BookmarkGroup)
}

class BookmarkThumbnailHeaderView: NSView {
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var collapseButton: NSButton!
    weak var delegate: BookmarkThumbnailHeaderViewDelegate?
    
    weak var group: BookmarkGroup? {
        didSet {
            if let g = group {
                title.stringValue = g.title
                collapseButton.title = g.isCollapsed ? "expand" : "collapse"
            }
            
        }
    }
    
    @IBAction func onCollapseButtonPressed(_ sender: NSButton) {
        if let g = group {
            delegate?.onCollapseButtonPressed(forGroup: g)
        }
    }
    
    override func awakeFromNib() {
        self.wantsLayer = true
//        self.layer?.backgroundColor = CGColor(gray: 0.9, alpha: 1)
    }
}
