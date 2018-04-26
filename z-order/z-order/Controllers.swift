//
//  ViewController.swift
//  z-order
//
//  Created by gietal-dev on 2/14/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 1...3 {
            var w = MyWindowController()
            w.label = "\(i)"
            windows.append(w)
            w.showWindow(self)
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    var windows = [MyWindowController]()

    @IBAction func resetWindows(_ sender: Any) {
        let screenFrame = NSScreen.screens()!.first!.visibleFrame
        var origin = screenFrame.origin
        origin.x += screenFrame.width / 2
        origin.y += screenFrame.height / 2
        
        if windows.count == 2 {
            var w = MyWindowController()
            w.label = "\(3)"
            windows.append(w)
        }
        
        var gap = NSPoint(x: 100, y: -50)
        for i in 0..<3 {
            windows[i].window?.orderFront(self)
            windows[i].window?.setFrameOrigin(origin)
            
            origin.x += gap.x
            origin.y += gap.y
        }
    }

    @IBAction func doZOrder(_ sender: Any) {
        // order front A B 
        windows[0].window!.orderFront(self)
        windows[1].window!.order(.above, relativeTo: windows[0].window!.windowNumber)
        windows[2].window!.order(.above, relativeTo: windows[1].window!.windowNumber)
        
        windows[0].window!.orderFront(self)
        windows[1].window!.order(.above, relativeTo: windows[0].window!.windowNumber)
        
        // order out C
//        windows[2].window!.orderOut(self)
        windows[2].window!.close()
        windows.remove(at: 2)
    }
}

class MyWindowController: NSWindowController {
    
    public convenience init() {
        self.init(windowNibName: "MyWindow")
    }
    public var label: String = ""
    
    override func windowDidLoad() {
        textField.stringValue = label
    }
    @IBOutlet weak var textField: NSTextField!
}

class MyWindow: NSWindow {
    
}
