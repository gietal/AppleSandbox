//
//  ViewController.swift
//  TestSandboxedApp2
//
//  Created by gietal-dev on 9/6/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let standard = UserDefaults.standard
        Swift.print("standard userdefaults: \(standard.string(forKey: "sandbox.userdefaults.type"))")
        let shared = UserDefaults(suiteName: "UBF8T346G9.com.gietal.sandbox")
        Swift.print("shared userdefaults: \(shared?.string(forKey: "sandbox.userdefaults.type"))")
        let direct = UserDefaults(suiteName: "com.gietal.sandbox.TestSandboxedApp")
        Swift.print("direct userdefaults: \(direct?.string(forKey: "sandbox.userdefaults.type"))")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

