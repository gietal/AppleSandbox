//
//  ContentView.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class ContentViewController: NSViewController {
    
    @IBOutlet weak var label: NSTextFieldCell!

    static var viewCount = 0
    
    override func viewDidLoad() {
        ContentViewController.viewCount += 1
        label.title = "Content View \(ContentViewController.viewCount)"
    }
}
