//
//  WindowManager.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

// 1 for each session
class WindowManager {
    
    
    public func goFullScreen() {
        //NSMenu.setMenuBarVisible(false)
        applyToWinControllers {
            $0.fullscreen = true
        }
    }
    
    public func goWindowed() {
        NSMenu.setMenuBarVisible(true)
        applyToWinControllers {
            $0.fullscreen = false
        }
    }
    
    public var screens = [ScreenLayout]() {
        didSet {
            windowControllers.removeAll()
//            for s in screens {
//                let winController = FakeFullscreenWindowController()
//                winController.layout = s
//                winController.delegate = self
//                windowControllers[s.layoutId] = winController
//                
//                // calculate aabb
//            }
            let bound = calculateBoundingBox(screens: screens)
            
            // make new screen layout
            let s = ScreenLayout()
            s.isPrimary = true
            s.layoutId = 0
            s.bounds = bound
            
            let winController = FakeFullscreenWindowController()
            winController.layout = s
            winController.delegate = self
            windowControllers[s.layoutId] = winController
        }
    }
    
    public func calculateBoundingBox(screens: [ScreenLayout]) -> CGRect {
        if screens.count == 0 {
            return CGRect()
        }
        var minPoint = CGPoint(x: Int.max, y: Int.max)
        var maxPoint = CGPoint(x: -Int.max, y: -Int.max)
        for s in screens {
            minPoint.x = min(minPoint.x, s.bounds.minX)
            minPoint.y = min(minPoint.y, s.bounds.minY)
            maxPoint.x = max(maxPoint.x, s.bounds.maxX)
            maxPoint.y = max(maxPoint.y, s.bounds.maxY)
        }
        let width = maxPoint.x - minPoint.x
        let height = maxPoint.y - minPoint.y
        return CGRect(x: minPoint.x, y: minPoint.y, width: width, height: height)
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

extension WindowManager: FakeFullscreenWindowControllerDelegate {
    func windowRequestedFullscreen() {
        goFullScreen()
    }
    
    func windowRequestedWindowed() {
        goWindowed()
    }
}
