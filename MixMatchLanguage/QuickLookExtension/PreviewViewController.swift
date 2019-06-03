//
//  PreviewViewController.swift
//  QuickLookExtension
//
//  Created by gietal-dev on 5/10/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa
import Quartz
import SwiftFramework

class PreviewViewController: NSViewController, QLPreviewingController {
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
    }

    public func preparePreviewOfSearchableItem(identifier: String, queryString: String?, completionHandler handler: @escaping (Error?) -> Void) {
        // Perform any setup necessary in order to prepare the view.
        
        let url = getAppGroupApplicationSupportDirectory()
        print("appex support dir: \(url.absoluteString)")
        
        let result = FileManager.default.fileExists(atPath: url.appendingPathComponent("hello.txt").path)
        print("file exist: \(result)")
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        handler(nil)
    }

}
