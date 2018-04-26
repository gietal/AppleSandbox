//
//  ViewController.swift
//  stripping
//
//  Created by gietal-dev on 9/20/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

import Cocoa

public class FindMeClass {
    public func hello() {
        findmeValue = 123
    }
    public var findmeValue = 0
}
class ViewController: NSViewController {
    @IBOutlet weak var label: NSTextField!
    let findmeclass = FindMeClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        findme()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func findmepressed(_ sender: Any) {
        findmeclass.hello()
        label.stringValue = String("findmeValue: \(findmeclass.findmeValue)")
    }

    fileprivate func findme() {
        Swift.print("hello findme")
    }

}

