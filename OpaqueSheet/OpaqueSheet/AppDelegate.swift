//
//  AppDelegate.swift
//  OpaqueSheet
//
//  Created by gietal-dev on 1/22/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window.contentView?.layer?.backgroundColor = NSColor.yellow.cgColor
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openSheet(_ sender: Any) {
        let vc = SheetViewController()
        let sheetWindow = NSWindow(contentViewController: vc)
        window.beginSheet(sheetWindow, completionHandler: { (response) in
            
        })
    }
    
}

