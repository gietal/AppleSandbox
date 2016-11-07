//
//  WindowController.swift
//  CustomTitleBar
//
//  Created by Gieta Laksmana on 10/5/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var inWindow: INAppStoreWindow!
    
    let titleBar = TitleBarViewController()
    
    convenience init() {
        self.init(windowNibName: "MainWindow")
    }
    
    override func awakeFromNib() {
        contentViewController = titleBar
    }
    
    override func windowDidLoad() {
        titleBar.setupTrafficLightButtons()
    }
    
    func makeTrafficLightConstraint() {
        
    }
}
