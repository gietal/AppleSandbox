//
//  ViewController.swift
//  windowParenting
//
//  Created by gietal-dev on 6/28/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func makeChildWindow(_ sender: NSButton) {
        view.window?.title = "Parent"
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateController(withIdentifier: "MainWinController") as? NSWindowController,
            let win = controller.window {
            self.view.window?.addChildWindow(win, ordered: .above)
            let newPos = win.frame.origin.applying(CGAffineTransform(translationX: 30, y: -30))
            win.setFrameOrigin(newPos)
            win.title = "Child"
//            win.frame = CGRect(origin: newPos, size: win.frame.size)
        }
        
    }


}

