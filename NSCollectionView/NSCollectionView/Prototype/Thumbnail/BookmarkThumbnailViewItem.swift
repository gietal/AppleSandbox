//
//  ThumbnailViewItem.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/19/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class BookmarkThumbnailViewItem: NSCollectionViewItem {
    
    var bookmark: Bookmark? {
        didSet {
            if let b = bookmark {
                hostnameLabel.stringValue = b.hostname
                usernameLabel.stringValue = b.username ?? ""
                imageView?.image = b.image
            } else {
                imageView?.image = nil
                hostnameLabel.stringValue = ""
                usernameLabel.stringValue = ""
            }
        }
    }
    @IBOutlet weak var hostnameLabel: NSTextField!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var contentView: NSView!
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5 : 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        contentView.wantsLayer = true
        contentView.layer?.borderColor = NSColor.black.cgColor
        contentView.layer?.borderWidth = 1
//        contentView.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.borderColor = NSColor.orange.cgColor
        view.layer?.borderWidth = 0
    }
}
