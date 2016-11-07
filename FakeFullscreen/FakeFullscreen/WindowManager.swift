//
//  WindowManager.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class WindowManager {
    
    public func goFullScreen() {
        //NSMenu.setMenuBarVisible(false)
        applyToWinControllers {
            $0.fullscreen = true
            $0.reframe()
        }
    }
    
    public func goWindowed() {
        NSMenu.setMenuBarVisible(true)
        applyToWinControllers {
            $0.fullscreen = false
            $0.reframe()
        }
    }
    
    public var screens = [ScreenLayout]() {
        didSet {
            windowControllers.removeAll()
            for s in screens {
                let winController = FakeFullscreenWindowController()
                winController.layout = s
                windowControllers[s.layoutId] = winController
            }
        }
    }
    
    public func showAllWindows() {
        applyToWinControllers {
            $0.showAndKey()
        }
    }
    
    private func applyToWinControllers(_ block: (FakeFullscreenWindowController) -> Void) {
        for w in windowControllers {
            block(w.value)
        }
    }
    
    var windowControllers = [Int: FakeFullscreenWindowController]()
    
}
