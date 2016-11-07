//
//  CustomWindowController.swift
//  fullscreenMenuBar
//
//  Created by Gieta Laksmana on 9/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

public class CustomWindowController: NSWindowController {
    
    static var windowCount = 0
    
    var windowId = 0
    
    override public func windowDidLoad() {
        window!.delegate = self
        windowId = CustomWindowController.windowCount
        CustomWindowController.windowCount += 1
        
    }
    
    private let queue = dispatch_queue_create("com.microsoft.rdc.test.queue.sessiontests", DISPATCH_QUEUE_SERIAL);
    
    public class func create() -> CustomWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateControllerWithIdentifier("CustomWindowController") as! CustomWindowController
        controller.window?.collectionBehavior.insert(.FullScreenDisallowsTiling)

        return controller
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        /*
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(onMenuBeginTracking(_:)),
            name: NSMenuDidBeginTrackingNotification,
            object: nil
        )
        
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(
            self,
            selector: #selector(activeSpaceDidChange(_:)),
            name: NSWorkspaceActiveSpaceDidChangeNotification,
            object: nil
        )
        */
    }
    
}

extension CustomWindowController: NSWindowDelegate {
    
    func onMenuBeginTracking(notification: NSNotification){
        print("asd")
    }
    
    func activeSpaceDidChange(notification: NSNotification) {
        if window!.keyWindow {
            window?.orderFront(self)
        }
        
    }
    
    public func windowWillEnterFullScreen(notification: NSNotification) {
        print("window will enter fullscreen")
    }
    
    public func windowWillExitFullScreen(notification: NSNotification) {
        print("window will exit fullscreen")
    }
    
    public func windowDidEnterFullScreen(notification: NSNotification) {
        print("window did enter fullscreen")
        NSMenu.setMenuBarVisible(false)
    }
    
    public func windowDidExitFullScreen(notification: NSNotification) {
        print("window did exit fullscreen")
    }
    
    public func windowDidResignKey(notification: NSNotification) {
        print("window did resign key")
    }
    
    public func windowDidBecomeKey(notification: NSNotification) {
        print("window did become key")
        //if windowId == 1 {
        NSMenu.setMenuBarVisible(false)
        //}
    }
    
    public func windowDidFailToEnterFullScreen(window: NSWindow) {
        print("window did fail to enter fullscreen")
    }
    
    public func windowDidFailToExitFullScreen(window: NSWindow) {
        print("window did fail to exit fullscreen")
    }
    
    public func windowWillClose(notification: NSNotification) {
        print("window will close")
    }
}