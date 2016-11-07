//
//  CustomMenuBar.swift
//  fullscreenMenuBar
//
//  Created by Gieta Laksmana on 9/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

public class CustomMenuBar: NSMenu {
    
    public override func awakeFromNib() {
        delegate = self
    }
}

extension CustomMenuBar: NSMenuDelegate {
    public func menuWillOpen(menu: NSMenu) {
        print("menu will open: \(menu.title)")
    }
    
    public func menuNeedsUpdate(menu: NSMenu) {
        print("menu needs update: \(menu.title)")
    }
}