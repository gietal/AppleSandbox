//
//  AppDelegate.swift
//  ImageTint
//
//  Created by gietal-dev on 29/10/18.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var templateCircle: NSImageView!
    @IBOutlet weak var templateTriangle: NSImageView!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        CALayer *sublayer = [CALayer layer];
//        [sublayer setBackgroundColor:[UIColor whiteColor].CGColor];
//        [sublayer setOpacity:0.3];
//        [sublayer setFrame:toBeTintedImage.frame];
//        [toBeTintedImage.layer addSublayer:sublayer];
        
//        templateCircle.wantsLayer = true
////        templateCircle.layer?.backgroundColor = NSColor.red.cgColor
//        let layer = CALayer()
//        layer.backgroundColor = NSColor.red.cgColor
//        layer.opacity = 1
//        layer.frame = templateCircle.frame
//        templateCircle.layer?.addSublayer(layer)
//        templateCircle.image = tintedImage(templateCircle.image!, tint: NSColor.red)
//        templateTriangle.image = tintedImage(templateTriangle.image!, tint: NSColor.red)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func tintedImage(_ image: NSImage, tint: NSColor) -> NSImage {
        guard let tinted = image.copy() as? NSImage else { return image }
        tinted.lockFocus()
        tint.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        tinted.unlockFocus()
        return tinted
    }

}

