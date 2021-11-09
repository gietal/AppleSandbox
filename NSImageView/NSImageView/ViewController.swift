//
//  ViewController.swift
//  NSImageView
//
//  Created by gietal on 11/9/21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = 5
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

@IBDesignable
open class CircularButton: NSButton {
    open var hoveredColor: NSColor? = NSColor.alternateSelectedControlColor
    fileprivate var blurFilter: CIFilter?
    fileprivate var colorLayer = CALayer()
    fileprivate var blurLayer = CALayer()
    fileprivate let additionalGrayColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    open override func awakeFromNib() {
        // setup these props manually so you can't accidentally set it from the UI
        bezelStyle = .shadowlessSquare
        setButtonType(.momentaryPushIn)
        isBordered = false
        
        wantsLayer = true
        layer?.cornerRadius = frame.width / 2
        layer?.masksToBounds = true
        layerUsesCoreImageFilters = true
        
        let trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        
        blurFilter = CIFilter(name:"CIGaussianBlur")
        blurFilter?.name = "blur"
        blurFilter?.setValue(10, forKey: "inputRadius")
        
        
        blurLayer.frame = CGRect(origin: .zero, size: bounds.size)
        blurLayer.backgroundFilters = [blurFilter!]
        
        colorLayer.frame = CGRect(origin: .zero, size: bounds.size)
        
        colorLayer.backgroundColor = additionalGrayColor
        
        colorLayer.compositingFilter = CIFilter(name: "CIOverlayBlendMode")!
        
//        layer?.addSublayer(<#T##layer: CALayer##CALayer#>)
        layer?.sublayers = [colorLayer]
        layer?.backgroundFilters = [blurFilter!]
    }
    
    fileprivate func applyBlur() {
//        layer?.borderWidth = 1
//        layer?.borderColor = NSColor.white.cgColor
        if let filter = blurFilter {
            layer?.backgroundFilters = [filter]
            layer?.setValue(10, forKeyPath: "backgroundFilters.\(filter.name).inputRadius")
            layer?.masksToBounds = true
        }
    }
    
    open override func mouseEntered(with event: NSEvent) {
        if let hoveredColor = hoveredColor {
//            layer?.backgroundColor = hoveredColor.cgColor
            colorLayer.backgroundColor = hoveredColor.cgColor
        }
    }
    
    open override func mouseExited(with event: NSEvent) {
//        layer?.backgroundColor = CGColor(gray: 1, alpha: 0.5)
//        layer?.backgroundColor = nil
        colorLayer.backgroundColor = additionalGrayColor
        
        
        // need to reapply blur after changing the background color
//        applyBlur()
    }
}
