//
//  FakeFullscreenWindow.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class FakeFullscreenWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}
