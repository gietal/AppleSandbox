//
//  CustomView.swift
//  fullscreenMenuBar
//
//  Created by Gieta Laksmana on 9/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

public class CustomView: NSView {
    
    private var trackingArea: NSTrackingArea? {
        didSet {
            if let oldTrackingArea = oldValue {
                removeTrackingArea(oldTrackingArea)
            }
        }
    }
    
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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        let options: NSTrackingAreaOptions = [.ActiveAlways, .MouseEnteredAndExited, .MouseMoved, .CursorUpdate, .InVisibleRect]
        let trackingArea = NSTrackingArea(rect: visibleRect, options: options, owner: self, userInfo: nil)
        self.trackingArea = trackingArea
        addTrackingArea(trackingArea)
    }
    
    
    public override func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent)
    }
}