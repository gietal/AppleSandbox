//
//  AppDelegate.swift
//  aspectRatioResize
//
//  Created by gietal-dev on 5/7/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window.contentAspectRatio = NSSize(width: 1.0, height: 0.5)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

