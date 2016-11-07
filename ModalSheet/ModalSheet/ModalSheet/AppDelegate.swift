//
//  AppDelegate.swift
//  ModalSheet
//
//  Created by Gieta Laksmana on 8/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa
import CocoaLumberjackSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        DDLogHelper.initializeLogging()
        
        DDLogVerbose("app loaded")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


    
    
}

