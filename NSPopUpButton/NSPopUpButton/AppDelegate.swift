//
//  AppDelegate.swift
//  NSPopUpButton
//
//  Created by Gieta Laksmana on 11/28/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBOutlet weak var popUpButton: NSPopUpButtonCell!

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var setIndexButton: NSButton!
    @IBAction func onIndexChanged(_ sender: NSPopUpButton) {
        let oldIndex = cacheOldIndex
        let newIndex = popUpButton.objectValue as? Int
        cacheOldIndex = newIndex!
        print("on index changed, old: \(oldIndex), new: \(newIndex)")
    }

    var cacheOldIndex = 0
    
    internal var selectedIndex: AnyObject! {
        didSet {
            let oldIndex = oldValue as? Int
            let newIndex = selectedIndex as? Int
            print("selectedIndex didSet, old: \(oldIndex), new: \(newIndex)")
        }
    }
    
    internal var contents: [String] {
        return ["index 0", "index 1", "index 2"]
    }
    
    @IBAction func selectItemButtonPresssed(_ sender: NSButton) {
        let index = Int(textField.stringValue)
        Swift.print("select index programmatically to: \(index)")
        popUpButton.selectItem(at: index!)
    }
}

