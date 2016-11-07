// Copyright © Microsoft Corporation 2014

import Foundation
import Cocoa

/// Handles mouse cursor changes and scroll events.
public final class GestureRecognizerView: NSView {
    
    // MARK: Public Properties
    
    public var delegate: TemplateViewDelegate?
    
    /// Whether the cursor is hidden.
    public var cursorHidden: Bool = false {
        didSet(cursorWasHidden) {
            if cursorInArea && cursorWasHidden != cursorHidden {
                if cursorHidden {
                    NSCursor.hide()
                } else {
                    NSCursor.unhide()
                }
            }
        }
    }
    
    @IBOutlet var outputTextView: NSTextView!
    
    @IBAction func OnLoadPreferenceButtonPressed(sender: NSButtonCell) {
        delegate?.onLoadUserDefaults(NSUserDefaults.standardUserDefaults())
    }
    
    @IBAction func OnClearButtonPressed(sender: NSButton) {
        outputTextView.textStorage?.setAttributedString(NSAttributedString(string: ""))
    }
    
    /// The cursor.
    public var cursor: NSCursor? {
        didSet {
            if cursorInArea && !cursorHidden {
                cursor?.set()
            }
        }
    }
    
    // MARK: Private Properties
    
    private var trackingArea: NSTrackingArea? {
        didSet {
            if let oldTrackingArea = oldValue {
                removeTrackingArea(oldTrackingArea)
            }
        }
    }
    
    private var cursorInArea = false
    private var cursorHasMoved = false
    
    // MARK: Public Methods
    
    public func convertPoint(point: NSPoint, sessionRegionOfInterest: NSRect) -> NSPoint  {
        var newPoint = convertPoint(point, fromView: nil)
        
        guard (sessionRegionOfInterest.size != CGSizeZero) && (frame.size != CGSizeZero) else {
            return newPoint
        }
        
        let scaleX = frame.width / sessionRegionOfInterest.width
        let scaleY = frame.height / sessionRegionOfInterest.height
        
        newPoint.x /= scaleX
        newPoint.x += sessionRegionOfInterest.origin.x
        
        newPoint.y = frame.height - newPoint.y;
        newPoint.y /= scaleY
        
        newPoint.y += sessionRegionOfInterest.origin.y
        
        return newPoint
    }
    
    // MARK: NSView Overrides
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        let options: NSTrackingAreaOptions = [.ActiveAlways, .MouseEnteredAndExited, .MouseMoved, .CursorUpdate, .InVisibleRect]
        let trackingArea = NSTrackingArea(rect: visibleRect, options: options, owner: self, userInfo: nil)
        self.trackingArea = trackingArea
        addTrackingArea(trackingArea)
        
        // set the delegate here
        let debugView = TrackpadTestViewDelegate()
        debugView.onDebugLogging = self.appendOutputTextView
        delegate = debugView
        
        acceptsTouchEvents = delegate?.shouldAcceptTouch() ?? false
        
        delegate?.onAwakeFromNib()
        
        appendOutputTextView("awake from Nib")
    }
    
    private func appendOutputTextView(message: String) {
        outputTextView.textStorage?.appendAttributedString(NSAttributedString(string: message + "\n"))
        outputTextView.scrollLineDown(nil)
    }
    
    // MARK: NSResponder Overrides
    
    override public func mouseEntered(theEvent: NSEvent) {
        cursorInArea = true
        cursorHasMoved = false
        if cursorHidden {
            NSCursor.hide()
        }
        
        delegate?.onMouseEntered()
    }
    
    override public func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent)
        if (!hidden && !cursorHasMoved) {
            cursor?.set()
            cursorHasMoved = true
        }
        
        delegate?.onMouseMoved()
    }
    
    override public func mouseExited(theEvent: NSEvent) {
        cursorInArea = false
        cursorHasMoved = false
        if cursorHidden {
            NSCursor.unhide()
        }
        
        delegate?.onMouseExited()

    }
    
    override public func cursorUpdate(event: NSEvent) {
        if !cursorHidden && cursorHasMoved {
            cursor?.set()
        }
        
        delegate?.onCursorUpdate()
    }
    
    override public func mouseUp(theEvent: NSEvent) {

        delegate?.onMouseUp(theEvent)
    }
    
    override public func mouseDown(theEvent: NSEvent) {
        
        delegate?.onMouseDown(theEvent)
    }
    
    override public func rightMouseUp(theEvent: NSEvent) {
        delegate?.onRightMouseUp(theEvent)
    }
    
    override public func rightMouseDown(theEvent: NSEvent) {
        delegate?.onRightMouseDown(theEvent)
    }
    
    override public func otherMouseUp(theEvent: NSEvent) {
        delegate?.onOtherMouseUp(theEvent)
    }
    
    override public func otherMouseDown(theEvent: NSEvent) {
        delegate?.onOtherMouseDown(theEvent)
    }
    
    override public func scrollWheel(theEvent: NSEvent) {
        // Check if the scroll wheel event should be sent to the mouse driver or forwarded down the NSResponder chain.
        if !(delegate?.shouldSendScrollWheel() ?? true) {
            super.scrollWheel(theEvent)
            return
        }
        
        var scrollingDeltaX = theEvent.scrollingDeltaX
        var scrollingDeltaY = theEvent.scrollingDeltaY
        
        // Reduce sensitivity if mouse event is not precise.
        if (!theEvent.hasPreciseScrollingDeltas) {
            let magicMultiplier: CGFloat = 400
            scrollingDeltaX *= magicMultiplier
            scrollingDeltaY *= magicMultiplier
        }
        
        let dx = Int(round(scrollingDeltaX))
        let dy = Int(round(scrollingDeltaY))
        
        delegate?.sendMouseWheelMove(dx: dx, dy: dy)
    }
    
    // MARK: app specific gesture
    
    private var overrideOneFingerTap = true
    private var overrideTwoFingerTap = true
    private var overrideThreeFingerTap = true
    private var clashWithThreeFingerDrag = false
    private var skipOneLeftMouseClick = false
    
    // this only works if the user enabled "Look up and data detectors with 3 fingers tap"
    override public func quickLookWithEvent(theEvent: NSEvent) {
        delegate?.onQuickLook(theEvent)
    }
    
    override public func touchesBeganWithEvent(theEvent: NSEvent) {
        
        let touches = theEvent.touchesMatchingPhase(.Began, inView: self)

        delegate?.onTouchesBegan(touches, theEvent: theEvent)
    }
    
    override public func touchesEndedWithEvent(theEvent: NSEvent){
        
        let touches = theEvent.touchesMatchingPhase(.Ended, inView: self)

        delegate?.onTouchesEnded(touches, theEvent: theEvent)
    }
    
    override public func touchesCancelledWithEvent(theEvent: NSEvent) {
        
        let touches = theEvent.touchesMatchingPhase(.Cancelled, inView: self)
        delegate?.onTouchesCancelled(touches, theEvent: theEvent)
        
    }
    
    override public func touchesMovedWithEvent(theEvent: NSEvent) {
        
        let touches = theEvent.touchesMatchingPhase(.Moved, inView: self)
        delegate?.onTouchesMoved(touches, theEvent: theEvent)
    }
}
