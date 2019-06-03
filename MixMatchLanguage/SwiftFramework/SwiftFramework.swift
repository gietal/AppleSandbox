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

public func getApplicationSupportDirectory() -> URL {
    let bundleID = Bundle.main.bundleIdentifier!
    let fileMgr = FileManager.default
    var dirPath: URL
    
    let appSupportDir = fileMgr.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    if appSupportDir.count > 0 {
        dirPath = appSupportDir.first!.appendingPathComponent(bundleID, isDirectory: true)
    } else {
        dirPath = fileMgr.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent(bundleID, isDirectory: true)
    }
    
    do {
        try fileMgr.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
    } catch let createError {
        print("error getting app suport directory: \(createError)")
        return fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first as! URL
    }
    return dirPath
}

public func getAppGroupApplicationSupportDirectory() -> URL {
    let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "DTT6RZZAQ3.com.gietal.mixmatch")!
    return sharedContainerURL.appendingPathComponent("Library/Application Support")
}
