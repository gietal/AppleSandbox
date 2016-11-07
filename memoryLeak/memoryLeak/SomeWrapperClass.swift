//
//  SomeWrapperClass.swift
//  memoryLeak
//
//  Created by Gieta Laksmana on 9/13/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

open class SomeWrapperClass {
    
    let theProcotol: SomeProtocol
    
    public init(prot: SomeProtocol) {
        Swift.print("SomeWrapperClass init")
        self.theProcotol = prot
    }
    
    deinit {
        Swift.print("SomeWrapperClass deinit")
    }
    
}
