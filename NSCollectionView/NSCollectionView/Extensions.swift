//
//  Array+Extensions.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/20/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa


extension Array {
    
    mutating func remove(at positions: Set<Int>) -> [Element] {
        var removed = [Element]()
        var i = 0
        while i < self.count {
            if positions.contains(i + removed.count) {
                // remove this
                removed.append(self.remove(at: i))
            } else {
                // skip this one
                i += 1
            }
        }
        return removed
    }
}

extension Dictionary {
    func contains(key: Key) -> Bool {
        return self.index(forKey: key) != nil
    }
}

extension NSCollectionView.DropOperation: CustomDebugStringConvertible {
    public var debugDescription: String {
        if self == .on {
            return "on"
        } else if self == .before {
            return "before"
        }
        return "unknown"
    }
}

extension NSDragOperation: CustomDebugStringConvertible {
    public var debugDescription: String {
        if self == .none {
            return "none"
        }
        
        var output = ""
        if self.contains(.copy) {
            output += "copy | "
        }
        if self.contains(.link) {
            output += "link | "
        }
        if self.contains(.private) {
            output += "private | "
        }
        if self.contains(.move) {
            output += "move | "
        }
        if self.contains(.delete) {
            output += "delete | "
        }
        if self.contains(.every) {
            output += "every | "
        }
        return output
    }
}
