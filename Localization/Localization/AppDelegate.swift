//
//  AppDelegate.swift
//  Localization
//
//  Created by gietal on 4/5/19.
//  Copyright © 2019 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var subtitle: NSTextField!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let str = NSLocalizedString("SUBTITLE", value: "Subtitle is generated from code", comment: "subtitle from code")
        subtitle.stringValue = str
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

