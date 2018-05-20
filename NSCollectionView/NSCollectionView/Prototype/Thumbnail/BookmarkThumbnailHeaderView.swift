//
//  BookmarkThumbnailHeaderView.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/19/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class BookmarkThumbnailHeaderView: NSView {
    @IBOutlet weak var title: NSTextField!
    weak var group: BookmarkGroup? {
        didSet {
            title.stringValue = group?.title ?? ""
        }
    }
    
    override func awakeFromNib() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
}
