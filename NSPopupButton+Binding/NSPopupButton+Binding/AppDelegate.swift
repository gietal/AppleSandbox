//
//  AppDelegate.swift
//  NSPopupButton+Binding
//
//  Created by gietal-dev on 5/6/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa

public class DebugPopupButton: NSPopUpButton {
    public override func selectItem(at index: Int) {
        super.selectItem(at: index)
    }
    
    public override func selectItem(withTitle title: String) {
        super.selectItem(withTitle: title)
    }
    
    public override func selectItem(withTag tag: Int) -> Bool {
        return super.selectItem(withTag: tag)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var arrayController: NSArrayController!
    
    @IBOutlet weak var popupButton: DebugPopupButton!
    
    @objc internal var arrayControllerSelectionIndexSet: IndexSet? {
        didSet {
            
        }
    }
    
    // this is toggled when user modify the popup button
    @objc internal var popupButtonSelectionIndex: NSNumber? {
        get {
            return arrayController.selectionIndex as NSNumber
        }
        set {
            if let n = newValue {
                arrayController.setSelectionIndexes(IndexSet(integer: Int(n)))
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        arrayController.addObject(1)
        arrayController.addObject(2)
        arrayController.addObject(3)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showSheet(_ sender: Any) {
        let sheetController = SheetViewController()
        
        window.beginSheet(NSWindow(contentViewController: sheetController), completionHandler: { _ in
        
        })
        
    }
    
    @IBAction func selectTwo(_ sender: Any) {
        popupButton.selectItem(at: 1)
    }
}

