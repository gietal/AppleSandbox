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
    fileprivate let additionalGrayColor = CGColor(gray: 0.5, alpha: 0.4)
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
        blurFilter?.setValue(5, forKey: "inputRadius")
        
        
        blurLayer.frame = CGRect(origin: .zero, size: bounds.size)
        blurLayer.backgroundFilters = [blurFilter!]
        
        colorLayer.frame = CGRect(origin: .zero, size: bounds.size)
        
        colorLayer.backgroundColor = additionalGrayColor
        
//        colorLayer.compositingFilter = CIFilter(name: "CIOverlayBlendMode")!
        colorLayer.compositingFilter = CIFilter(name: "CIHardLightBlendMode")!
        
//        layer?.addSublayer(<#T##layer: CALayer##CALayer#>)
//        layer?.sublayers = [colorLayer]
//        layer?.backgroundFilters = [blurFilter!]
//        layer?.backgroundColor = CGColor(gray: 0.5, alpha: 0.4)
        
        setButtonColor(hovered: false)
    }
    
    fileprivate func setButtonColor(hovered: Bool) {
        if hovered && hoveredColor != nil {
            // remove the color sublayer
//            layer?.sublayers?.removeAll(where: { $0 === colorLayer })
            layer?.backgroundColor = hoveredColor!.cgColor
            
        } else {
            // reapply sublayer and blur
//            layer?.backgroundColor = nil
//            layer?.sublayers?.append(colorLayer)
            layer?.backgroundFilters = [blurFilter!]
            layer?.backgroundColor = additionalGrayColor
        }
    }
    
    open override func mouseEntered(with event: NSEvent) {
//        setButtonColor(hovered: true)
    }
    
    open override func mouseExited(with event: NSEvent) {
        setButtonColor(hovered: false)
    }
}
