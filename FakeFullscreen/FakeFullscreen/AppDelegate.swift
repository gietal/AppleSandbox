//
//  AppDelegate.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let winManager = WindowManager()
    let connCenter = ConnectionCenterWindowController()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        connCenter.showWindow(self)
        connCenter.window?.makeKeyAndOrderFront(self)
        
        // hardcode my screen layout for testing
        // this is in cocoa coordinate which means
        // origin is in the bottom left of the primary screen
        // up and right are the positive direction
        
        let s1 = ScreenLayout()
        s1.layoutId = 0
        s1.isPrimary = true
        s1.bounds = CGRect(x: 0, y: 0, width: 2048, height: 1152)
        let s2 = ScreenLayout()
        s2.layoutId = 1
        s2.isPrimary = false
        s2.bounds = CGRect(x: -1920, y: -128, width: 1920, height: 1200)
        
        winManager.screens = [s1]
        
        winManager.showAllWindows()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }


    @IBAction func goFullscreen(_ sender: NSMenuItem) {
        winManager.goFullScreen()
    }
    @IBAction func goWindowed(_ sender: NSMenuItem) {
        winManager.goWindowed()
    }
}

