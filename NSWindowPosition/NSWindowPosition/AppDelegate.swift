//
//  AppDelegate.swift
//  NSWindowPosition
//
//  Created by gietal-dev on 7/3/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func upButtonPressed(_ sender: NSButton) {
        var pos = window.frame.origin
        pos.y += 200
        window.setFrameOrigin(pos)
    }
    
    @IBAction func downButtonPressed(_ sender: NSButton) {
        var pos = window.frame.origin
        pos.y -= 50
        window.setFrameOrigin(pos)
    }
}

