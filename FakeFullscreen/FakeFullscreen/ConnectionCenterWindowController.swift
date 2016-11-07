//
//  ConnectionCenterWindowController.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/7/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class ConnectionCenterWindowController: NSWindowController {
    convenience init() {
        self.init(windowNibName: "ConnectionCenter")
    }
}
