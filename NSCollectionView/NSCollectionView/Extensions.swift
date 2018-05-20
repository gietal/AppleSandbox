//
//  Array+Extensions.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/20/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
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
