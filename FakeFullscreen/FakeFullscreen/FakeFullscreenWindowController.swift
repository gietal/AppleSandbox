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
            reframe(useCache: false)
        }
    }
    
    fileprivate func reframe(useCache: Bool) {
        if useCache {
            window?.setFrame(cachedWindowedFrame, display: true)
            window?.setContentSize(cachedWindowedFrame.size)
            return
        }
        
        let multimon = false
        
        if multimon {
            // multimon, use the window's composite bounds
            window?.setFrame(layout.bounds, display: true)
            window?.setContentSize(layout.bounds.size)
        } else {
            // single mon, use current monitor as frame
            if let screenFrame = window?.screen?.frame {
                window?.setFrame(screenFrame, display: true)
                window?.setContentSize(screenFrame.size)
            }
        }
        
    }
    
    fileprivate let fullscreenStyleMask: NSWindowStyleMask = [.borderless, .fullSizeContentView, .closable /*.fullScreen*/]
    fileprivate let windowedStyleMask: NSWindowStyleMask = [.resizable, .titled]

    
    public var fullscreen: Bool = false {
        didSet {
            // if not changed, do nothing
            if fullscreen == oldValue {
                return
            }
            
            if fullscreen {
                cacheWindowFrame()
                reframe(useCache: false) // reframe to screen layout
                window?.styleMask.insert(fullscreenStyleMask)
                window?.styleMask.remove(windowedStyleMask)
                window?.hasShadow = false
                hideTitleBar()
                hideMenuBar()
                window?.debugPrintWindowStyle()
                reframe(useCache: false) // reframe to screen layout
                
            } else {
                window?.styleMask.remove(fullscreenStyleMask)
                window?.styleMask.insert(windowedStyleMask)
                window?.hasShadow = true
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
        window?.isMovable = false
        window?.isMovableByWindowBackground = false
        window?.standardWindowButton(.closeButton)?.isHidden = true
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        
        // attach traffic lights
        for b in trafficLights {
            //window?.contentView?.addSubview(b)
        }
    }

    fileprivate func showTitleBar() {
        //window?.styleMask.insert([.titled])
        //return;
        
        window?.titleVisibility = .visible
        window?.titlebarAppearsTransparent = false
        window?.isMovable = true
        window?.standardWindowButton(.closeButton)?.isHidden = false
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = false
        window?.standardWindowButton(.zoomButton)?.isHidden = false
        
        // remove traffic light
        for b in trafficLights {
            //b.removeFromSuperview()
        }
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








