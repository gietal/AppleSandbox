//
//  ViewController.swift
//  TestSandboxedApp
//
//  Created by gietal-dev on 9/5/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let standard = UserDefaults.standard
        standard.set("standard user defaults", forKey: "sandbox.userdefaults.type")
        let shared = UserDefaults(suiteName: "UBF8T346G9.com.gietal.sandbox")
        shared?.set("shared user defaults", forKey: "sandbox.userdefaults.type")
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

