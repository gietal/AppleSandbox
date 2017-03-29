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
    
    fileprivate var trafficLights: [NSButton] = []
    public convenience init() {
        self.init(windowNibName: "FakeFullscreenWindow")
        
        trafficLights.append(NSWindow.standardWindowButton(.closeButton, for: fullscreenStyleMask)!)
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
            //reframeWindow(withCachedFrame: false)
        }
    }
    
    fileprivate func reframeWindow(withCachedFrame: Bool) {
        if withCachedFrame {
            window?.setFrame(cachedWindowedFrame, display: true)
            return
        }
        
        if !isSingleMon {
            // multimon, use the window's composite bounds
            window?.setFrame(layout.bounds, display: true)
            
        } else if isSingleMon {
            // single mon, use current monitor as frame
            if let screenFrame = window?.screen?.frame {
                window?.setFrame(screenFrame, display: true)
            }
        }
    }
    
    fileprivate let singlemonFullscreenStyleMask: NSWindowStyleMask = [.fullScreen]
    fileprivate let singlemonWindowedStyleMask: NSWindowStyleMask = [.resizable]
    fileprivate let multimonFullscreenStyleMask: NSWindowStyleMask = [.borderless, .fullSizeContentView, /*.fullScreen*/]
    fileprivate let multimonWindowedStyleMask: NSWindowStyleMask = [.resizable, .titled]
    
    fileprivate var fullscreenStyleMask: NSWindowStyleMask {
        if isSingleMon {
            return singlemonFullscreenStyleMask
        }
        return multimonFullscreenStyleMask
    }
    
    fileprivate var windowedStyleMask: NSWindowStyleMask {
        if isSingleMon {
            return singlemonWindowedStyleMask
        }
        return multimonWindowedStyleMask
    }
    
    fileprivate var isSingleMon: Bool {
        return true
    }
    
    public var fullscreen: Bool = false {
        didSet {
            // if not changed, do nothing
            if fullscreen == oldValue {
                return
            }
            
            if fullscreen {
                enterCustomFullscreen()
            } else {
                exitCustomFullscreen()
            }
        }
    }
    
    fileprivate func enterCustomFullscreen() {
        cacheWindowFrame()
        
        // go 'fullscreen'
        window?.styleMask.insert(fullscreenStyleMask)
        window?.styleMask.remove(windowedStyleMask)
        
        window?.hasShadow = false
        
        // hide menu bar and dock
        hideMenuBar()
        hideTitleBar()
        
        // resize window to screen layout
        reframeWindow(withCachedFrame: false)
        
    }
    
    fileprivate func exitCustomFullscreen() {
        // go windowed
        window?.styleMask.remove(fullscreenStyleMask)
        window?.styleMask.insert(windowedStyleMask)
        
        window?.hasShadow = true
        
        // show menu bar and dock
        showMenuBar()
        showTitleBar()
        
        // resize window back to before fullscreen
        reframeWindow(withCachedFrame: true)
        
    }
    
    fileprivate func hideTitleBar() {
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        window?.isMovable = false // this causes the menu bar to push the window down when it shows, if window has title bar
        window?.standardWindowButton(.closeButton)?.isHidden = true
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    fileprivate func showTitleBar() {
        window?.titleVisibility = .visible
        window?.titlebarAppearsTransparent = false
        window?.isMovable = true
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
    
    func isFullscreen() -> Bool {
        guard let styleMask = window?.styleMask else {
            return false
        }
        
        return styleMask.contains(fullscreenStyleMask) && !styleMask.contains(windowedStyleMask)
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
    
    @IBAction func close(_ sender: Any?) {
        close()
    }
}

extension FakeFullscreenWindowController: NSWindowDelegate {
    
    func windowDidBecomeKey(_ notification: Notification) {
        if fullscreen {
            hideMenuBar()
        } else {
            showMenuBar()
        }
    }
    
    func windowDidResignKey(_ notification: Notification) {
        if fullscreen {
            showMenuBar()
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        
    }
}








