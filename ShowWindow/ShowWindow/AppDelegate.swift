//
//  AppDelegate.swift
//  ShowWindow
//
//  Created by Gieta Laksmana on 1/24/17.
//  Copyright © 2017 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    fileprivate var win1 = NSWindowController()
    fileprivate var win2 = NSWindowController()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let storyboard = NSStoryboard(name: "MyStoryboard", bundle: nil)
        win1 = storyboard.instantiateController(withIdentifier: "asdf") as! NSWindowController
        win1.window?.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

