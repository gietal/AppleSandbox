//  Copyright © 2016 Microsoft. All rights reserved.

import Foundation

public extension NSXMLElement {
    
    /// Returns the child element with the given name if there's only one, otherwise returns nil.
    public func elementForName(name: String) -> NSXMLElement? {
        let elements = self.elementsForName(name)
        return elements.count == 1 ? elements.first : nil
    }
}
