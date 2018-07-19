//
//  AppDelegate.swift
//  MenuBarApp
//
//  Created by Gieta Laksmana on 12/30/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let popover = NSPopover()
    popover.setAllowedOnAllSpaces()

    let popoverStatusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            // hide
            popover.performClose(sender)
        } else {
            // show
                        if let button = popoverStatusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = popoverStatusItem.button {
            button.image = NSImage(named: "icon")
            //button.target = self
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        //        statusItemViewController = StatusItemViewController()
        //        statusItemViewController!.delegate = self
        //        popoverWindowController = PopoverWindowController()
        //        popoverWindowController!.statusItemViewFrame = statusItemViewController!.statusItemFrame
        //        popoverWindowController!.connectionCenterViewController = connectionCenterViewController
        //        popoverWindowController!.delegate = self
        
        popover.contentViewController = EmptyViewController()
        //popover.behavior = .semitransient

        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    

}

