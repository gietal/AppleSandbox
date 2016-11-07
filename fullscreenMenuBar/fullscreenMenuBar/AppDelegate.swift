//
//  AppDelegate.swift
//  fullscreenMenuBar
//
//  Created by Gieta Laksmana on 9/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    

}

extension AppDelegate: NSMenuDelegate {
    internal func menuWillOpen(menu: NSMenu) {
        print("menu will open: \(menu.title)")
    }
    
    internal func menuNeedsUpdate(menu: NSMenu) {
        print("menu needs update: \(menu.title)")
    }
}