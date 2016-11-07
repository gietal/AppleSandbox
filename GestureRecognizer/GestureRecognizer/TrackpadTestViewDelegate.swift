//
//  DebugViewDelegate.swift
//  GestureRecognizer
//
//  Created by Gieta Laksmana on 7/21/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import Cocoa
import CocoaLumberjackSwift

public class TrackpadTestViewDelegate: TemplateViewDelegate {
    
    public var onDebugLogging: ((String) -> Void)?
    
    private var touchGestureDetectors = [TrackpadGestureDetector]()
    private var trackpadPrefs = TrackpadPreference()
    
        /* = [
        //ThreeFingerTapDetector()
        FingerTapDetector(
            fingerNumToDetect: 1,
            trackingRadius: 1.0,
            handleGestureCallback: fingerTapGestureHandler
        ),
        
        FingerTapDetector(
            fingerNumToDetect: 2,
            gestureToReturn: .TwoFingerTap,
            trackingRadius: 105.0
        ),
        
        FingerTapDetector(
            fingerNumToDetect: 3,
            gestureToReturn: .ThreeFingerTap,
            trackingRadius: 140.0
        )
    ]*/
    
    public func onAwakeFromNib() {
        
        // add gesture handlers

        touchGestureDetectors.append(
            OneFingerTapDetector(
                handleGestureCallback: self.fingerTapGestureHandler
                )
        )
        
        touchGestureDetectors.append(
            TwoFingerTapDetector(
                handleGestureCallback: self.fingerTapGestureHandler
            )
        )
        
        touchGestureDetectors.append(
            ThreeFingerTapDetector(
                handleGestureCallback: self.fingerTapGestureHandler
            )
        )
        
        // read system preference
        onLoadUserDefaults(NSUserDefaults.standardUserDefaults())
        
    }
    
    public func onLoadUserDefaults(settings: NSUserDefaults) {
        
        logMessage("loading user preference from nsuserdefaults")
        trackpadPrefs.setValues(with: settings)
        
        logMessage("tap to click enabled    : \(trackpadPrefs.isTapToClickEnabled)") // this is the 1 finger click
        logMessage("secondary click enabled : \(trackpadPrefs.isSecondaryClickEnabled)") // tap/click with 2 finger, will be 0 if click corner is selected
        logMessage("quicklook enabled       : \(trackpadPrefs.isQuickLookEnabled)") // 1 - bottom left, 2 - bottom right, will be 0 if tap/click with 2 finger is selected
        logMessage("3 finger drag enabled   : \(trackpadPrefs.isThreeFingerDragEnabled)")
        
        for detector in touchGestureDetectors {
            detector.setPreference(trackpadPrefs)
        }
    }
    
    // gesture handler //
    private func fingerTapGestureHandler(detector: TrackpadGestureDetector, event: NSEvent) {
        
        if let tapDetector = detector as? FingerTapDetector {
            
            logMessage("\(tapDetector.fingerNumToDetect) finger tap detected")
            
            switch tapDetector.fingerNumToDetect {
                
            case 1:
                logMessage("performing left click")
                onMouseDown(event)
                onMouseUp(event)
                break
                
            case 2:
                logMessage("performing right click")
                onRightMouseDown(event)
                onRightMouseUp(event)
                break
                
            case 3:
                logMessage("performing middle click")
                logMessage("mouse button 2 down")
                logMessage("mouse button 2 up")
                //onOtherMouseDown(event)
                //onOtherMouseUp(event)
                
            default:
                break
            }
        }
    }
    
    private func logMessage(msg: String) {
        DDLogVerbose(msg)
        onDebugLogging?(msg)
    }
    
    public func shouldSendScrollWheel() -> Bool {
        return true
    }
    

    public func sendMouseWheelMove(dx dx: Int, dy: Int) {
        
    }
    

    public func onMouseUp(event: NSEvent) {
        
        for detector in touchGestureDetectors {
            
            let consumed = detector.mouseUp(event)
            
            // mouse up consumed, stop processing event
            if consumed {
                return
            }
        }
        
        logMessage("left mouse up")
    }
    
    public func onMouseDown(event: NSEvent) {
        
        for detector in touchGestureDetectors {
            
            let consumed = detector.mouseDown(event)
            
            // mouse up consumed, stop processing event
            if consumed {
                return
            }
        }
        
        // assume below is the delegate
        logMessage("left mouse down")
    }
    
    public func onRightMouseUp(event: NSEvent) {
        logMessage("right mouse up")
    }
    
    public func onRightMouseDown(event: NSEvent) {
        logMessage("right mouse down")
    }
    
    public func onOtherMouseUp(event: NSEvent) {
        logMessage("mouse button \(event.buttonNumber) up")
    }
    
    public func onOtherMouseDown(event: NSEvent) {
        logMessage("mouse button \(event.buttonNumber) down")
    }
    
    public func onMouseEntered() {
        logMessage("mouse entered")
    }
    
    public func onMouseExited(){
        logMessage("mouse exited")
    }
    
    public func onMouseMoved(){
        //logMessage("mouse moved")
    }
    
    public func onCursorUpdate(){
        logMessage("cursor updated")
    }
    
    public func onQuickLook(event: NSEvent){
        logMessage("quick look")
    }
    
    public func shouldAcceptTouch() -> Bool{
        return true
    }
    
    public func onTouchesBegan(touches: Set<NSTouch>, theEvent: NSEvent) {
        for touch in touches {
            logMessage("touch \(getTouchHashId(touch)) began")
        }
        for detector in touchGestureDetectors {
            detector.touchesBegan(touches, event: theEvent)
        }
    }
    
    public func onTouchesEnded(touches: Set<NSTouch>, theEvent: NSEvent) {
        for touch in touches {
            logMessage("touch \(getTouchHashId(touch)) ended")
        }
        for detector in touchGestureDetectors {
            detector.touchesEnded(touches, event: theEvent)
        }
    }
    
    public func onTouchesCancelled(touches: Set<NSTouch>, theEvent: NSEvent) {
        for touch in touches {
            logMessage("touch \(getTouchHashId(touch) ) cancelled")
        }
        for detector in touchGestureDetectors {
            detector.touchesCancelled(touches, event: theEvent)
        }
    }
    
    public func onTouchesMoved(touches: Set<NSTouch>, theEvent: NSEvent) {
        for touch in touches {
            //logMessage("touch \(touch.identity.hash) moved")
        }
        for detector in touchGestureDetectors {
            detector.touchesMoved(touches, event: theEvent)
        }
    }
    
    private func getTouchHashId(touch: NSTouch) -> Int {
        return touch.identity.hash % 100
    }
}