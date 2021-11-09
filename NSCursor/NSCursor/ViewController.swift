//
//  ViewController.swift
//  NSCursor
//
//  Created by gietal on 6/4/21.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

class TrackingView: NSView {
    override func awakeFromNib() {
        super.awakeFromNib()
        let options: NSTrackingArea.Options = [NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.inVisibleRect]
        let trackingArea = NSTrackingArea(rect: visibleRect, options: options, owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        NSCursor.closedHand.set()
    }
    
    override func mouseMoved(with event: NSEvent) {
//        NSCursor.closedHand.set()
    }
}
