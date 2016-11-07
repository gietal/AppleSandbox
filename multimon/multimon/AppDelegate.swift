//
//  AppDelegate.swift
//  multimon
//
//  Created by Gieta Laksmana on 10/24/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let windowController1 = PrimaryWindowController()
    let windowController2 = AuxWindowController()
    let mainWindowController = MainWindowController()
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        
        guard let priWindow = windowController1.window, let auxWindow = windowController2.window, let mainWindow = mainWindowController.window else {
            return
        }

        
        mainWindowController.showWindow(self)
        windowController1.showWindow(self)
        windowController2.showWindow(self)
        
        mainWindow.makeKeyAndOrderFront(self)
        auxWindow.makeKeyAndOrderFront(self)
        priWindow.makeKeyAndOrderFront(self)
        
        //auxWindow.collectionBehavior.insert(.fullScreenAuxiliary)
        //priWindow.makeKeyAndOrderFront(self)
        
//        window1.makeKeyAndOrderFront(self)
//        
//        windowController1.labelText = "Window 1"
//        windowController2.labelText = "Window 2"
//        
//        if let screens = NSScreen.screens() {
//            window1.collectionBehavior = .fullScreenPrimary
//            window2.collectionBehavior = .fullScreenAuxiliary
//            //window2.window?.collectionBehavior.insert([.fullScreenAuxiliary])
//            //window2.styleMask.insert(.borderless)
//            var superFrame = NSRect()
//            superFrame.size.width = screens[0].frame.width + screens[1].frame.width
//            superFrame.size.height = max(screens[0].frame.height, screens[1].frame.height)
//            superFrame.origin.x = min(screens[0].frame.origin.x, screens[1].frame.origin.x)
//            superFrame.origin.y = 0
//            
//            //window1.window?.contentView
//            window1.setFrame(screens[0].frame, display: true)
//            window2.setFrame(screens[1].frame, display: true)
//            
//            //window1.window?.toggleFullScreen(self)
//            //window2.window?.toggleFullScreen(self)
//        }
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

