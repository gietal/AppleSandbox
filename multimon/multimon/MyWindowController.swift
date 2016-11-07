//
//  MyWindowController.swift
//  multimon
//
//  Created by Gieta Laksmana on 10/24/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class MyWindowController: NSWindowController {
    
    @IBOutlet weak var textField: NSTextFieldCell!

    public var labelText: String = "" {
        didSet {
            textField.title = labelText
        }
    }
    
    convenience init() {
        self.init(windowNibName: "MyWindowController")
    }
    
}

class PrimaryWindowController: NSWindowController {
    convenience init() {
        self.init(windowNibName: "PrimaryWindow")
    }
}

class AuxWindowController: NSWindowController, NSWindowDelegate {
    convenience init() {
        self.init(windowNibName: "AuxWindow")
    }
    
    override func awakeFromNib() {
        window?.delegate = self
    }
    
    func windowDidEnterFullScreen(_ notification: Notification) {
        window?.collectionBehavior = .managed
        //window?.level =
    }
    func windowDidResize(_ notification: Notification) {
        //window?.collectionBehavior = .managed
    }
}

class MainWindowController: NSWindowController {
    convenience init() {
        self.init(windowNibName: "MainWindow")
    }
}

class KeyableWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}
