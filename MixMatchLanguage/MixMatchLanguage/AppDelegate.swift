//
//  AppDelegate.swift
//  MixMatchLanguage
//
//  Created by gietal-dev on 5/10/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa
import SwiftFramework

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let swiftClass = SwiftClass()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        swiftClass.doStuff()
        swiftClass.objcClass.doStuff()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

