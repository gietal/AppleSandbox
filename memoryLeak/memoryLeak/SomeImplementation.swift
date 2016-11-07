//
//  SomeImplementation.swift
//  memoryLeak
//
//  Created by Gieta Laksmana on 9/13/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

open class SomeImplementation: SomeProtocol {
    open var asd: Bool = false
    
    public init() {
        Swift.print("SomeImplementation init")
    }
    
    deinit {
        Swift.print("SomeImplementation deinit")
    }
}
