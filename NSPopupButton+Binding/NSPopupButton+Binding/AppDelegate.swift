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
            print("---------------------")
        }
        super.selectItem(at: index)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var arrayController: NSArrayController!
    @IBOutlet weak var popupButton: DebugPopupButton!
    
    @objc internal var arrayControllerSelectionIndexSet: IndexSet? {
        didSet {
            print("arrayControllerSelectionIndexSet = \(arrayControllerSelectionIndexSet?.first)")
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
                print("popupButtonSelectionIndex = \(index)")
                arrayController.setSelectionIndexes(IndexSet(integer: index))
//                arrayControllerSelectionIndexSet = IndexSet(integer: Int(n))
                popupButton.selectItem(at: index)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        popupButton.appDelegate = self
        arrayController.addObject(1)
        arrayController.addObject(2)
        arrayController.addObject(3)
    }

    @IBAction func showSheet(_ sender: Any) {
        let sheetController = SheetViewController()
        
        window.beginSheet(NSWindow(contentViewController: sheetController), completionHandler: { _ in
        
        })
        
    }
    
    @IBAction func selectTwo(_ sender: Any) {
        // no matter how I try to set the selected index to be index 1 programmatically here
        // when I show a sheet, [NSValueBinder _revertDisplayValueBackToOriginalValue] would revert it
        // to the index explicitly selected from the UI by the user
        let index = 1
        popupButton.selectItem(at: index)
        popupButtonSelectionIndex = index as NSNumber
        arrayControllerSelectionIndexSet = IndexSet(integer: index)
        arrayController.setSelectionIndex(index)
    }
    
}

