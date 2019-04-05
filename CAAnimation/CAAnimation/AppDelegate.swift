//
//  AppDelegate.swift
//  CAAnimation
//
//  Created by gietal on 1/16/19.
//  Copyright © 2019 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var theView: NSButton!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    @IBAction func runAnimation(_ sender: Any) {
        var animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [theView.frame.origin.x - 10, theView.frame.origin.y]
        animation.toValue = [theView.frame.origin.x+10, theView.frame.origin.y]
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.isRemovedOnCompletion = true
        
        theView.layer?.add(animation, forKey: "position")
    }
}

