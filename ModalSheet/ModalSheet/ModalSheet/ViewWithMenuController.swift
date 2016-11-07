//
//  ViewWithMenuController.swift
//  ModalSheet
//
//  Created by Gieta Laksmana on 8/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import Cocoa

public class ViewWithMenuController: NSViewController {
    
    convenience init() {
        self.init(nibName: "ViewWithMenu", bundle: nil) // which view to use for this controller
        
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
        DDLogVerbose("view with menu controller loaded")
    }
    
}