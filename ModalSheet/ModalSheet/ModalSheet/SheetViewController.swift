//
//  SheetViewController.swift
//  ModalSheet
//
//  Created by Gieta Laksmana on 8/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa
import CocoaLumberjackSwift

public class SheetViewController: NSViewController {
    
    convenience init() {
        self.init(nibName: "SheetView", bundle: nil) // which view to use for this controller
        
    }
    
    @IBOutlet var theView: NSView!
    
    override init!(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DDLogVerbose("sheet view controller loaded")
    }
    
    override public var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    @IBAction func onCloseButtonClicked(sender: NSButton) {
        // close the sheet
        DDLogVerbose("close sheet button clicked")
        if let win = view.window {
            DDLogVerbose("closing sheet")
            win.sheetParent?.endSheet(win)
        }
    }
}