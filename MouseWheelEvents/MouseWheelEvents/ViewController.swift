//
//  ViewController.swift
//  MouseWheelEvents
//
//  Created by gietal on 5/12/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var label: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.activeAlways, .mouseMoved], owner: self, userInfo: nil))
    }
    
    @IBAction func onResetButtonPressed(_ sender: Any) {
        deltaYHistory = []
        momentumPhaseHistory = []
        updateText()
    }
    
    var deltaYHistory = [CGFloat]()
    var momentumPhaseHistory = [NSEvent.Phase]()
    
    fileprivate func updateText() {
        label.stringValue = "phases: \(momentumPhaseHistory)\n\(deltaYHistory)"
    }
    
    override func scrollWheel(with event: NSEvent) {
        deltaYHistory.append(event.scrollingDeltaY)
        momentumPhaseHistory.append(event.momentumPhase)
        updateText()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension NSEvent.Phase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .began:
            return "Began"
        case .cancelled:
            return "Cancelled"
        case .changed:
            return "Changed"
        case .ended:
            return "Ended"
        case .mayBegin:
            return "MayBegin"
        case .stationary:
            return "Stationary"
        default:
            return "Unknown(\(rawValue))"
        }
    }
}

