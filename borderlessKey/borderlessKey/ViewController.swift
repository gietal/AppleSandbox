//
//  ViewController.swift
//  borderlessKey
//
//  Created by gietal-dev on 9/25/17.
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

    @IBAction func toggleTitle(_ sender: Any) {
        if let window = view.window {
            if window.styleMask.contains(.titled) {
                window.styleMask.insert(.borderless)
                window.styleMask.remove([.titled, .resizable])
            } else {
                window.styleMask.remove(.borderless)
                window.styleMask.insert([.titled, .resizable])
            }
        }
    }
    
    var createdWindows = [BorderlessWindowController]()

    @IBAction func createWindow(_ sender: Any) {
        let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "BorderlessWindowController") as! BorderlessWindowController
        controller.window?.styleMask = view.window!.styleMask
        controller.showWindow(self)
        createdWindows.append(controller)
    }
}

