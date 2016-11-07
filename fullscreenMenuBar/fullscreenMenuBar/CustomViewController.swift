//
//  ViewController.swift
//  fullscreenMenuBar
//
//  Created by Gieta Laksmana on 9/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

class CustomViewController: NSViewController {

    private var done = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // separate thread to update a label to tell us if the menu bar is visible or not
        let queue = dispatch_queue_create("com.sandbox.gietal.fullscreenmenu", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(queue) {
            while(!self.done) {
                self.labelOutlet.title = "Menu Bar is Visible: \(NSMenu.menuBarVisible())"
            }
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private var otherWindowControllers = [CustomWindowController]()

    @IBAction func spawnWindowButton(sender: AnyObject) {
        let controller = CustomWindowController.create()
        controller.showWindow(self)
        otherWindowControllers.append(controller) // needed at least 1 strong reference to prevent the window to go away
    }
    
    @IBOutlet weak var labelOutlet: NSTextFieldCell!
    
    deinit {
        otherWindowControllers.removeAll()
        done = true
    }

}

