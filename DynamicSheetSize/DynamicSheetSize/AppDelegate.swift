//
//  AppDelegate.swift
//  DynamicSheetSize
//
//  Created by gietal-dev on 6/3/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let sheetVC = SheetViewController()
        window.beginSheet(SheetWindow(contentViewController: sheetVC), completionHandler: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

