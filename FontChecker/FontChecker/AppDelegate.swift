//
//  AppDelegate.swift
//  FontChecker
//
//  Created by gietal-dev on 15/10/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        for size in 1...100 {
            let f = NSFont.systemFont(ofSize: CGFloat(size))
            print("size: \(size), font: \(f), matrix: \(f.matrix)")
        }
       
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

