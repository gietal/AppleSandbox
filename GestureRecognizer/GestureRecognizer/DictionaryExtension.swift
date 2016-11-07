// Copyright (c) 2015 Microsoft. All rights reserved.

import Foundation

public extension Dictionary {
    
    /**
     Checks if a dictionary contains a key.
     
     - parameter key: The key of the element.
     
     - returns: true if the dictionary contains the element with a given key, otherwise false.
     */
    func contains(key: Key) -> Bool {
        return indexForKey(key) != nil
    }
    
}