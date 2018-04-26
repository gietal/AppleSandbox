//
//  AppDelegate.swift
//  NSMenu
//
//  Created by gietal-dev on 10/9/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var myMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let item = NSMenuItem(title: "hello", action: nil, keyEquivalent: "")
        let matched = myMenu.item(matching: item)
        Swift.print("asdf")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

