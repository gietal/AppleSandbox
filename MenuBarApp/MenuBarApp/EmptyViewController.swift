//
//  EmptyViewController.swift
//  MenuBarApp
//
//  Created by Gieta Laksmana on 12/30/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

//
//  EmptyViewController.swift
//  ClientMac
//
//  Created by Gieta Laksmana on 12/30/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import Cocoa
import ApplicationServices

class EmptyViewController: NSViewController {
    
    convenience init() {
        self.init(nibName: "EmptyView", bundle: nil)
    }
    
    override init!(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        isMenuBarApp = false
    }
    
    var isMenuBarApp = false {
        didSet {
            updateAgentStatus()
        }
    }
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var textCell: NSTextFieldCell!
    @IBAction func toggleAgent(_ sender: NSButton) {
        isMenuBarApp = !isMenuBarApp
        
    }
    
    func updateAgentStatus() {
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        if isMenuBarApp {
            // transform to agent
            TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToUIElementApplication))
        } else {
            // transform to non agent
            TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
        }
        textCell.title = "isMenuBarApp: \(isMenuBarApp)"
    }
}
