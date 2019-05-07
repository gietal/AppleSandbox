//
//  SheetWindowController.swift
//  NSPopupButton+Binding
//
//  Created by gietal-dev on 5/6/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class SheetViewController: NSViewController {
    
    convenience init() {
        self.init(nibName: "Sheet", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func dismissSheet(_ sender: Any) {
        if let window = view.window {
            window.sheetParent?.endSheet(window, returnCode: .OK)
        }
    }
}
