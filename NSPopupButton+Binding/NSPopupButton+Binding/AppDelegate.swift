//
//  AppDelegate.swift
//  NSPopupButton+Binding
//
//  Created by gietal-dev on 5/6/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa

public class DebugPopupButton: NSPopUpButton {
    
    internal weak var appDelegate: AppDelegate!
    
    public override func selectItem(at index: Int) {
        if let appDelegate = appDelegate {
            print("---- select item ----")
            print("index: \(index)")
            print("arrayController.selectionIndex: \(appDelegate.arrayController.selectionIndex)")
            print("arrayControllerSelectionIndexSet: \(appDelegate.arrayControllerSelectionIndexSet?.first)")
            print("popupButtonSelectionIndex: \(appDelegate.popupButtonSelectionIndex)")
        }
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
                let index = Int(n)
                arrayController.setSelectionIndexes(IndexSet(integer: index))
//                arrayControllerSelectionIndexSet = IndexSet(integer: Int(n))
                popupButton.selectItem(at: index)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        popupButton.appDelegate = self
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
        let index = 1
        popupButton.selectItem(at: index)
        popupButtonSelectionIndex = index as NSNumber
        arrayControllerSelectionIndexSet = IndexSet(integer: index)
        arrayController.setSelectionIndex(index)
    }
}

