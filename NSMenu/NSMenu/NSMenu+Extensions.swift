//
//  NSMenu+Extensions.swift
//  NSMenu
//
//  Created by gietal-dev on 10/9/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//
import Foundation
import Cocoa

extension NSMenu {
    public func optionalIndex(of item: NSMenuItem) -> Int? {
        let idx = index(of: item)
        if idx == -1 {
            return nil
        }
        return idx
    }
    
    public func item(matching item: NSMenuItem) -> NSMenuItem? {
        guard let index = optionalIndex(of: item) else {
            return nil
        }
        return self.item(at: index)
    }
}
