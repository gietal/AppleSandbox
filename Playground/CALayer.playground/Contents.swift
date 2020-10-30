//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

class ColorView: NSView {
    public var drawColor: NSColor = .blue
    
    override func awakeFromNib() {
        layer = CALayer()
        wantsLayer = true
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSGraphicsContext.saveGraphicsState()
        drawColor.set()
        dirtyRect.fill()
        NSGraphicsContext.restoreGraphicsState()
    }
    
//    override func updateLayer() {
//
//    }
    
}

let mainView = ColorView(frame: NSRect(x: 0, y: 0, width: 500, height: 500))
mainView.drawColor = .green

let teamsView = ColorView(frame: NSRect(x: 0, y: 0, width: 250, height: 250))
teamsView.drawColor = .blue

let maskView = ColorView(frame: NSRect(x: 75, y: 75, width: 100, height: 100))
maskView.drawColor = .yellow
maskView.layer = CALayer()
maskView.layer?.backgroundColor = .clear


mainView.addSubview(teamsView)
teamsView.addSubview(maskView)

// create the mask image which we will render to
// set the size to be the size of the teamsView since we are creating a mask for the teamsView
let maskImage = NSImage(size: teamsView.frame.size)
maskImage.addRepresentation(NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(teamsView.frame.size.width), pixelsHigh: Int(teamsView.frame.size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bitmapFormat: .alphaFirst, bytesPerRow: 0, bitsPerPixel: 0)!)

// start rendering to the image
maskImage.lockFocus()

// 1st, make everything opaque (only the alpha matters in a mask image, the color doesnt)
let context = NSGraphicsContext.current!.cgContext
context.setFillColor(NSColor.white.cgColor)
context.fill(teamsView.bounds)

// then chop off the area we dont want with clear color (alpha = 0)
context.clear(maskView.frame)

// finish rendering the image
maskImage.unlockFocus()

// next create a layer with the mask image as its content
// the layer size also has to be the size of the teamsView, since we are masking that view
let mask = CALayer()
mask.frame = teamsView.frame
mask.contents = maskImage

// assign the mask to the teamsView
teamsView.layer = CALayer()
teamsView.layer?.mask = mask// maskView.layer
teamsView.layer?.backgroundColor = NSColor.blue.cgColor


PlaygroundPage.current.liveView = mainView

//PlaygroundPage.current.liveView = NSImageView(image: maskImage)
