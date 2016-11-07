//
//  AppDelegate.swift
//  CustomTitleBar
//
//  Created by Gieta Laksmana on 10/5/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //@IBOutlet weak var window: CustomWindow!

    let mainWindow = WindowController()
    let titleBar = TitleBarViewController()
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindow.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }


}

