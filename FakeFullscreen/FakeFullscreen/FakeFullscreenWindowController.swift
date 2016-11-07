//
//  FakeFullscreenWindowController.swift
//  FakeFullscreen
//
//  Created by Gieta Laksmana on 11/4/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

public protocol FakeFullscreenWindowControllerDelegate: class {
    func windowRequestedFullscreen()
    
    func windowRequestedWindowed()
}

class FakeFullscreenWindowController: NSWindowController {
    
    public var delegate: FakeFullscreenWindowControllerDelegate?
    
    fileprivate var cachedWindowedFrame = CGRect()
    
    public convenience init() {
        self.init(windowNibName: "FakeFullscreenWindow")
    }
    
    public func cacheWindowFrame() {
        cachedWindowedFrame = window?.frame ?? cachedWindowedFrame
    }
    override func windowDidLoad() {
        window?.delegate = self
        window?.makeFirstResponder(self)
        cacheWindowFrame()
    }
    
    public func showAndKey() {
        showWindow(self)
        window?.makeKeyAndOrderFront(self)
    }
    
    public var layout = ScreenLayout() {
        didSet {
            reframe(useCache: false)
        }
    }
    
    fileprivate func reframe(useCache: Bool) {
        if useCache {
            window?.setFrame(cachedWindowedFrame, display: true)
            window?.setContentSize(cachedWindowedFrame.size)
        } else {
            window?.setFrame(layout.bounds, display: true)
            window?.setContentSize(layout.bounds.size)
        }
        
    }
    
    public var fullscreen: Bool = false {
        didSet {
            // if not changed, do nothing
            if fullscreen == oldValue {
                return
            }
            
            if fullscreen {
                window?.styleMask.insert([.fullSizeContentView, .borderless])
                window?.styleMask.remove([.resizable])
                hideTitleBar()
                hideMenuBar()
                cacheWindowFrame()
                reframe(useCache: false) // reframe to screen layout
            } else {
                window?.styleMask.remove([.fullSizeContentView, .borderless])
                window?.styleMask.insert([.resizable])
                showTitleBar()
                showMenuBar()
                reframe(useCache: true) // reframe to cache
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

// first responder for the window
extension FakeFullscreenWindowController {
    @IBAction func goFullscreen(_ sender: Any?) {
        delegate?.windowRequestedFullscreen()
    }
    
    @IBAction func goWindowed(_ sender: Any?) {
        delegate?.windowRequestedWindowed()
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








