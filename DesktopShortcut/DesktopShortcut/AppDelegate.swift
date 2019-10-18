//
//  AppDelegate.swift
//  DesktopShortcut
//
//  Created by gietal on 10/16/19.
//  Copyright © 2019 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillFinishLaunching(_ notification: Notification) {
        print("hello")
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let fileManager = FileManager.default
        let desktopUrl = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).last!
        
        let bookmarkUrl = desktopUrl.appendingPathComponent("test_alias")
        
//        let bookmarkData = bookmarkUrl
        let content = "hello".data(using: .utf8)
        let created = fileManager.createFile(atPath: bookmarkUrl.path, contents: content, attributes: nil)
        
//        print("file created: \(created)")
        
        let appPath = fileManager.currentDirectoryPath.appending("/DesktopShortcut.app")
        
        let appUrl = URL(fileURLWithPath: appPath)
        
        do {
            let alias = try appUrl.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
            try URL.writeBookmarkData(alias, to: bookmarkUrl)
        } catch {
            print("alias failed: \(error)")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

