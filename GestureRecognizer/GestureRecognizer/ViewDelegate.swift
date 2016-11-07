//
//  ViewDelegate.swift
//  GestureRecognizer
//
//  Created by Gieta Laksmana on 7/21/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa

/// template delegate to handle view events
public protocol TemplateViewDelegate: class {
    

    func shouldSendScrollWheel() -> Bool
    
    func sendMouseWheelMove(dx dx: Int, dy: Int)
    
    func onMouseUp(event: NSEvent)

    func onMouseDown(event: NSEvent)

    func onRightMouseUp(event: NSEvent)
    
    func onRightMouseDown(event: NSEvent)
    
    func onOtherMouseUp(event: NSEvent)
    
    func onOtherMouseDown(event: NSEvent)
    
    func onMouseEntered()
    
    func onMouseExited()
    
    func onMouseMoved()
    
    func onCursorUpdate()
    
    func onQuickLook(event: NSEvent)
    
    func shouldAcceptTouch() -> Bool
    
    func onTouchesBegan(touches: Set<NSTouch>, theEvent: NSEvent)
    
    func onTouchesEnded(touches: Set<NSTouch>, theEvent: NSEvent)
    
    func onTouchesCancelled(touches: Set<NSTouch>, theEvent: NSEvent)
    
    func onTouchesMoved(touches: Set<NSTouch>, theEvent: NSEvent)
    
    var onDebugLogging: ((String) -> Void)? {get set}
    
    func onAwakeFromNib()
    
    func onLoadUserDefaults(settings: NSUserDefaults)

}
