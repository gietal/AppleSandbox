//
//  AppDelegate.swift
//  NSColorBug
//
//  Created by gietal on 10/29/18.
//  Copyright © 2018 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var theview: NSView!
    
    @IBAction func resetPressed(_ sender: Any) {
        theview.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        theview.wantsLayer = true
        theview.layer?.borderColor = NSColor.green.cgColor
        theview.layer?.borderWidth = 5
        resetPressed(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

