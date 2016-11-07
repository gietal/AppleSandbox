//
//  CustomWindow.swift
//  fullscreenMenuBar
//
//  Created by Gieta Laksmana on 9/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import AppKit
import CoreGraphics
import CoreFoundation

public class CustomWindow: NSWindow {
    
    
    
    public override func mouseUp(theEvent: NSEvent) {
        //NSMenu.setMenuBarVisible(true)
return
        Swift.print("mouseUp at window coord \(theEvent.locationInWindow)")
        // create mouse moved event
        let mouseLoc = NSEvent.mouseLocation()
        Swift.print("global mouse location at \(mouseLoc)")
        
        // CGEventCreateMouseEvent needed mouse in global coordinate with origin on top left
        // but NSEvent.mouseLocation() give mouse location in global coordinate with origin on bottom left -_-
        // MUST ONLY WORK WITH FULLSCREENED WINDOW, otherwise frame.size wont be the whole screen
        let mouseMoveLoc = CGPoint(x: mouseLoc.x, y: frame.size.height - mouseLoc.y)
        let mouseMovedEvent = CGEventCreateMouseEvent(nil, CGEventType.MouseMoved, mouseMoveLoc, CGMouseButton.Left)
        
        // post mouse moved event
        Swift.print("posting mouseMoved event at \(mouseMoveLoc)")
        CGEventSetType(mouseMovedEvent, CGEventType.MouseMoved)
        CGEventPost(CGEventTapLocation.CGSessionEventTap, mouseMovedEvent)
        
        // delete mouse moved event
        //CFRelease(mouseMovedEvent)
    }
    
    private var timer: NSTimer?
    
    public override func mouseMoved(theEvent: NSEvent) {
        Swift.print("mouse moved \(theEvent.locationInWindow)")
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: false)
    }
    
    func onTimer() {
        Swift.print("asd")
        NSMenu.setMenuBarVisible(true)
    }
    
    public override func rightMouseUp(theEvent: NSEvent) {
        //NSMenu.setMenuBarVisible(false)
    }
}