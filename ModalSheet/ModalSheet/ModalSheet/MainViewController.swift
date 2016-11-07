//
//  MainViewController.swift
//  ModalSheet
//
//  Created by Gieta Laksmana on 8/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa
import CocoaLumberjackSwift

public class MainViewController: NSViewController {
    
    convenience init() {
        self.init(nibName: "MainView", bundle: nil) // which view to use for this controller
        
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
        
        //viewWithMenuController = ViewWithMenuController()
        //view.addSubview(viewWithMenuController!.view)
    }
    
    private var sheetViewController: SheetViewController?
    private var viewWithMenuController: ViewWithMenuController?
    
    @IBAction func onOpenSheetButtonClicked(sender: NSButton) {
        DDLogVerbose("open sheet button clicked")
        
        DDLogVerbose("opening sheet")
        sheetViewController = SheetViewController()
        let savedMenu = view.menu
        view.window?.beginSheet(NSWindow(contentViewController: sheetViewController!), completionHandler: {(response: NSModalResponse) in
            // this is a trick to retain weak pointer
            self.sheetViewController = nil
            DDLogVerbose("sheet closed")
        })
    }
    

}