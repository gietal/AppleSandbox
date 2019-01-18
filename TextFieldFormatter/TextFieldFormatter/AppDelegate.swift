//
//  AppDelegate.swift
//  TextFieldFormatter
//
//  Created by gietal-dev on 1/14/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa

class MyTextFormatter: Formatter {
//    override init() {
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func string(for obj: Any?) -> String? {
        return obj as? String
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if string == "" {
            obj?.pointee = string as AnyObject
            return true
        }
        
        error?.pointee = "error validating"
        return false
    }
    
}

extension NSImage {
    public func colored(_ color: NSColor) -> NSImage {
        guard let colored = self.copy() as? NSImage else {
            return self
        }
        
        let output = NSImage(size: self.size)
        output.lockFocus()
        let drawRect = NSRect(origin: NSPoint.zero, size: self.size)
        
        
        self.draw(in: drawRect)
//        colored.lockFocus()
        color.set()
        
        
        drawRect.fill(using: .sourceAtop) //sourceAtop
        
//        colored.unlockFocus()
        output.unlockFocus()
        return output
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var popover: NSPopover!
    @IBOutlet weak var popoverButton: NSButton!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        textField.formatter = MyTextFormatter()
        textField.delegate = self
        popoverButton.rotate(byDegrees: 180)
        popoverButton.needsDisplay = true
        
        popoverButton.image = popoverButton.image?.colored(NSColor.red)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func buttonPressed(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }
        
        if popover.isShown {
            // hide
            popover.performClose(self)
        } else {
            popover.show(relativeTo: NSRect.zero, of: button, preferredEdge: .maxX)
        }
    }
    
    @IBAction func toggleHide(_ sender: Any) {
        popoverButton.isHidden = !popoverButton.isHidden
        popover.close()
    }
}

extension AppDelegate: NSTextFieldDelegate {
    func control(_ control: NSControl, didFailToFormatString string: String, errorDescription error: String?) -> Bool {
        print("hello")
        return false
    }
    
    func control(_ control: NSControl, didFailToValidatePartialString string: String, errorDescription error: String?) {
        print("hello")
    }
}
