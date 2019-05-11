//
//  SwiftFramework.swift
//  SwiftFramework
//
//  Created by gietal-dev on 5/10/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Foundation

/*
 note:
 http://blog.bjhomer.com/2015/05/defining-modules-for-custom-libraries.html
 
 - create module.modulemap in the directory where the umbrella header is
 - add module.modulemap to objcLib's Module Map File build setting
 
 - add these files to the copy files phase of objcLib
   - ObjcLibUmbrella.h (or whatever umbrella header you use)
   - module.modulemap
 
 - link objcLib and cppLib static libs to SwiftFramework
 - add "-lc++" to Other Linker Flag of this framework
 - link SwiftFramework to the final swift app
*/
import ObjcLibModule

public class SwiftClass {
    public init() {
        
    }
    
    public let objcClass = ObjcClass()
    
    public func doStuff() {
        print("hello from swift framework")
        
        // call into objc
        objcClass.doStuff()
    }
}
