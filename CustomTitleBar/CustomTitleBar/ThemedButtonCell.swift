//  Copyright (c) 2015 Microsoft. All rights reserved.

import Foundation
import Cocoa

@IBDesignable open class RoundButton: NSButton {
    
    @IBInspectable open var diameter: CGFloat = 10 {
        didSet {
            var rect = self.bounds
            rect.size.width = diameter
            rect.size.height = diameter
            bounds = rect
        }
    }
    
    
}

open class RoundButtonCell: NSButtonCell {
    
    @IBInspectable open var buttonColor: NSColor = NSColor.gray
    @IBInspectable open var outlineColor: NSColor = NSColor.black
    @IBInspectable open var outlineWidth: CGFloat = 1.0
    @IBInspectable open var shouldDrawTitle: Bool = true {
        didSet {
            //self.draw
        }
    }

    required public init(coder: NSCoder) {
        super.init(coder: coder)
        bezelStyle = .texturedSquare
    }
    
    
    override open func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
        guard let gc = NSGraphicsContext.current() else {
            return
        }
        gc.shouldAntialias = true
        
        gc.saveGraphicsState()
        
        // create circle area to draw
        let path = NSBezierPath(ovalIn: frame)
        path.setClip()
        
        // set outline color and width
        outlineColor.setStroke()
        path.lineWidth = outlineWidth
        
        // set button color depending if it's clicked or not
        if isHighlighted {
            // if it's clicked, make it a little darker
            buttonColor.shadow(withLevel: 0.1)?.setFill()
        } else {
            // otherwise use original color
            buttonColor.setFill()

        }
        
        // draw the inside, then draw the outline
        path.fill()
        path.stroke()
        
        gc.restoreGraphicsState()
    }
    
    override open func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        if !shouldDrawTitle {
            return frame
        }
        let buttonFrame = controlView.bounds
        //let drawTo = NSRect(x: 0, y: 0, width: buttonFrame.width + frame.minX, height: 50)
        
        // find size of the text
        var titleFrame = NSRect(origin: CGPoint(x: 0, y: 0), size: title.size())

        // find how much the midpoint differ
        let deltaX = buttonFrame.midX - titleFrame.midX
        let deltaY = buttonFrame.midY - titleFrame.midY
        
        // translate the title frame by the delta
        titleFrame.origin.x += deltaX
        titleFrame.origin.y += deltaY
        
        titleFrame.origin.x = ceil(titleFrame.origin.x)
        titleFrame.origin.y = ceil(titleFrame.origin.y)
        // find the bottom left to start drawing text
        // by halfing the title frame,
        // then offset the origin of the center of the button frame by that much
        // we floor to avoid floating point, otherwise the text will be blurry
        //titleFrame.origin.x = floor(buttonFrame.midX - titleFrame.width / 2)
        //titleFrame.origin.y = floor(buttonFrame.midY - titleFrame.height / 2)
        

        title.draw(in: titleFrame)
        //let drawnOn = super.drawTitle(title, withFrame: drawTo, in: controlView)
        return titleFrame
    }
}

/// Returns the range of a string.
public extension NSAttributedString {
    
    /// Returns the range of a string.
    public func range() -> NSRange {
        return NSRange(location: 0, length: length)
    }
    
}

@IBDesignable open class DesignableButton: NSButton {
    
    // MARK: Public Properties
    
    @IBInspectable open var textColor: NSColor = NSColor.white {
        didSet {
            let title = NSMutableAttributedString(attributedString: attributedTitle)
            let titleRange = title.range()
            title.addAttribute(NSForegroundColorAttributeName, value: textColor, range: titleRange)
            attributedTitle = title
            sizeToFit()
        }
    }
    
    override open var font: NSFont? {
        didSet {
            let title = NSMutableAttributedString(attributedString: attributedTitle)
            let titleRange = title.range()
            if let font = self.font {
                title.addAttribute(NSFontAttributeName, value: font, range: titleRange)
            } else {
                title.removeAttribute(NSFontAttributeName, range: titleRange)
            }
            attributedTitle = title
            sizeToFit()
        }
    }
}


@IBDesignable open class ThemedButtonCell: NSButtonCell {
    
    // MARK: Public Properties
    @IBInspectable open var widthPadding: CGFloat = 20
    @IBInspectable open var heightPadding: CGFloat = 0
    @IBInspectable open var textWidthAdjustment: CGFloat = 0
    @IBInspectable open var textHeightAdjustment: CGFloat = -3
    @IBInspectable open var textColor: NSColor = NSColor.white {
        didSet {
            currentTextColor = textColor
        }
    }
    @IBInspectable open var highlightedTextColor: NSColor = NSColor.white
    @IBInspectable open var highlightedButtonColor: NSColor = NSColor.white
    @IBInspectable open var buttonColor: NSColor = NSColor.white {
        didSet {
            backgroundColor = buttonColor
        }
    }
    
    open var disabledButtonColor: NSColor {
        return buttonColor.withAlphaComponent(0.5)
    }
    
    open var currentTextColor: NSColor = NSColor.white
    
    override open var cellSize: NSSize {
        var buttonSize = super.cellSize
        buttonSize.width += 2.0 * widthPadding
        buttonSize.height += 2.0 * heightPadding
        return buttonSize
    }
    
    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = buttonColor
            } else {
                backgroundColor = disabledButtonColor
            }
        }
    }
    

    // MARK: Public Methods
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        var adjustedFrame = frame
        adjustedFrame.origin.y = frame.origin.y + textHeightAdjustment
        adjustedFrame.origin.x = frame.origin.x + textWidthAdjustment
        return super.drawTitle(title, withFrame: adjustedFrame, in: controlView)
    }
    
    override open func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        if flag {
            backgroundColor = highlightedButtonColor
            currentTextColor = highlightedTextColor
        } else {
            backgroundColor = buttonColor
            currentTextColor = textColor
        }
        
        changeButtonTitleColor()
        
        super.highlight(flag, withFrame: cellFrame, in: controlView)
    }
    
    // MARK: Internal Methods
    
    internal func changeButtonTitleColor() {
        let colorTitle = NSMutableAttributedString(attributedString: attributedTitle)
        let titleRange = NSMakeRange(0, colorTitle.length)
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: currentTextColor, range: titleRange)
        colorTitle.addAttribute(NSFontAttributeName, value: self.font!, range: titleRange)
        attributedTitle = colorTitle
    }
}
