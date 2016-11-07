//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Gieta Laksmana on 7/20/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userSettings = NSUserDefaults.standardUserDefaults()
        userSettings.integerForKey("ThreeFingerTapGesture")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

