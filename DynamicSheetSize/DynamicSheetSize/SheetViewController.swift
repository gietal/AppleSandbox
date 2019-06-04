//
//  SheetViewController.swift
//  DynamicSheetSize
//
//  Created by gietal-dev on 6/3/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class SheetViewController: NSViewController {
    
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var viewAHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCHeight: NSLayoutConstraint!
    
    var originalHeights = [NSLayoutConstraint: CGFloat]()
    convenience init() {
        self.init(nibName: NSNib.Name("SheetView"), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        urlTextField.delegate = self
        originalHeights[viewAHeight] = viewAHeight.constant
        originalHeights[viewBHeight] = viewBHeight.constant
        originalHeights[viewCHeight] = viewCHeight.constant
        
        // hide everything
        viewAHeight.constant = 0
        viewBHeight.constant = 0
        viewCHeight.constant = 0
    }
}

extension SheetViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        switch urlTextField.stringValue.count % 3 {
        case 0:
            // hide everything
            viewAHeight.animator().constant = 0
            viewBHeight.animator().constant = 0
            viewCHeight.animator().constant = 0
        case 1:
            // show 1
            viewAHeight.animator().constant = originalHeights[viewAHeight]!
            viewBHeight.animator().constant = 0
            viewCHeight.animator().constant = originalHeights[viewCHeight]!
        case 2:
            // show 2
            viewAHeight.animator().constant = originalHeights[viewAHeight]!
            viewBHeight.animator().constant = originalHeights[viewBHeight]!
            viewCHeight.animator().constant = originalHeights[viewCHeight]!
        default:
            break
        }
    }
}
