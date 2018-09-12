//
//  AppDelegate.swift
//  NSTextField
//
//  Created by gietal-dev on 30/08/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var label: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        label.wantsLayer = true
        label.layer?.cornerRadius = 5
        label.layer?.backgroundColor = NSColor.selectedTextBackgroundColor.cgColor
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

