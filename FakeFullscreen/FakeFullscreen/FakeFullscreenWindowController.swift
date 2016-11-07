//
//  FakeFullscreenWindowController.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

class FakeFullscreenWindowController: NSWindowController {
    
    public convenience init() {
        self.init(windowNibName: "FakeFullscreenWindow")
    }
    
    override func windowDidLoad() {
        window?.delegate = self
    }
    public func showAndKey() {
        showWindow(self)
        window?.makeKeyAndOrderFront(self)
    }
    
    public var layout = ScreenLayout() {
        didSet {
            reframe()
        }
    }
    
    public func reframe() {
        window?.setFrame(layout.bounds, display: true)
        window?.setContentSize(layout.bounds.size)
    }
    
    public var fullscreen: Bool = false {
        didSet {
            if fullscreen {
                window?.styleMask.insert([.fullSizeContentView, .borderless])
                window?.styleMask.remove([.resizable])
                hideTitleBar()
                hideMenuBar()
               
            } else {
                window?.styleMask.remove([.fullSizeContentView, .borderless])
                window?.styleMask.insert([.resizable])
                showTitleBar()
                showMenuBar()
            }
        }
    }
    
    fileprivate func hideTitleBar() {
        //window?.styleMask.remove([.titled])
        //return;
            
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        window?.standardWindowButton(.closeButton)?.isHidden = true
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
    }

    fileprivate func showTitleBar() {
        //window?.styleMask.insert([.titled])
        //return;
        
        window?.titleVisibility = .visible
        window?.titlebarAppearsTransparent = false
        window?.standardWindowButton(.closeButton)?.isHidden = false
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = false
        window?.standardWindowButton(.zoomButton)?.isHidden = false
    }
    
    fileprivate func showMenuBar() {
        NSApplication.shared().presentationOptions.remove([.hideDock, .autoHideMenuBar])
    }
    
    fileprivate func hideMenuBar() {
        NSApplication.shared().presentationOptions.insert([.hideDock, .autoHideMenuBar])
    }
}

extension FakeFullscreenWindowController: NSWindowDelegate {
    
    func windowDidBecomeKey(_ notification: Notification) {
        if fullscreen {
            hideTitleBar()
            hideMenuBar()
        } else {
            showTitleBar()
            showMenuBar()
        }
    }
    
    func windowDidResignKey(_ notification: Notification) {
        if fullscreen {
            showTitleBar()
            showMenuBar()
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        
    }
}








