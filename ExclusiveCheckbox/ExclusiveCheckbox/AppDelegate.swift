//
//  AppDelegate.swift
//  ExclusiveCheckbox
//
//  Created by gietal-dev on 5/1/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var button1: NSButton!
    @IBOutlet weak var button2: NSButton!
    
    
    @objc internal var value1: AnyObject! {
        willSet {
            willChangeValue(forKey: "value1")
            Swift.print("value1.willSet")
        }
        didSet {
            didChangeValue(forKey: "value1")
            Swift.print("value1.didSet")
            button1.state = toState(value1 as! Bool)

            if button1.state == .on {
                Swift.print("value1 turning value2 off")
                value2 = false as AnyObject
//                willChangeValue(forKey: "value2")
//                didChangeValue(forKey: "value2")
            }
        }
    }
    
    @objc internal var value2: AnyObject! {
        willSet {
            willChangeValue(forKey: "value2")
            Swift.print("value2.willSet")
        }
        didSet {
            didChangeValue(forKey: "value2")
            Swift.print("value2.didSet")
            button2.state = toState(value2 as! Bool)
            
            
            if button2.state == .on {
                Swift.print("value2 turning value1 off")
                value1 = false as AnyObject
//                willChangeValue(forKey: "value1")
//                didChangeValue(forKey: "value1")
            }
        }
    }
    
    
    func toState(_ bool: Bool) -> NSControl.StateValue {
        if bool {
            return .on
        }
        return .off
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

