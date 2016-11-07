//
//  ViewController.swift
//  ModalSheet
//
//  Created by Gieta Laksmana on 8/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Cocoa
import CocoaLumberjackSwift

public class ViewController: NSViewController {

    convenience init() {
        self.init(nibName: "MainView", bundle: nil) // which view to use for this controller
        
    }
    
    override init!(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DDLogVerbose("main view controller loaded")
        
        // load the main view
        mainVC = MainViewController()
        view.addSubview(mainVC!.view)
    }

    private var mainVC: MainViewController?
    
    
}

