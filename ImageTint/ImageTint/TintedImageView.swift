//
//  TintedImageView.swift
//  ImageTint
//
//  Created by gietal-dev on 29/10/18.
//

import Foundation
import AppKit

@IBDesignable
class TintedMaskImageView: NSImageView {
////    override var image: NSImage? {
////        didSet {
////            updateImage()
////        }
////    }
//    
//    
//    override var contentTintColor: NSColor? {
//        didSet {
//            updateImage()
//        }
//    }

    @IBInspectable
    var maskImage: NSImage? {
        didSet {
            updateImage()
        }
    }
    @IBInspectable
    var maskColor: NSColor? {
        didSet {
            updateImage()
        }
    }
    
    func updateImage() {
        if let originalImage = self.maskImage, let color = maskColor {
            self.image = tintedImage(originalImage, tint: color)
        } else {
            self.image = maskImage
        }
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
