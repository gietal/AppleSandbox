//
//  TitleBarViewController.swift
//  CustomTitleBar
//
//  Created by Gieta Laksmana on 10/11/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

class TitleBarViewController: NSViewController {
    convenience init() {
        self.init(nibName: "TitleBarView", bundle: nil)!
    }
    
    @IBOutlet weak var buttonCell: RoundButtonCell!
    @IBOutlet weak var closeButtonShadowView: TrafficLightShadowView!
    
    @IBAction func buttonPressed(_ sender: RoundButton) {
        buttonCell.shouldDrawTitle = !buttonCell.shouldDrawTitle
    }
    
//    public var closeButtonShadowView: TrafficLightShadowView {
//        if _closeButtonShadowView == nil {
//            _closeButtonShadowView = TrafficLightShadowView()
//            view.addSubview(_closeButtonShadowView!)
//        }
//        return _closeButtonShadowView!
//    }
    private var _closeButtonShadowView: TrafficLightShadowView?
    
    var buttonShadowConstraints = [NSLayoutConstraint]()
    var trafficLightConstraints: [NSLayoutConstraint]?
    

    override func viewDidAppear() {
        //setupTrafficLightButtons()
    }
    func setupTrafficLightButtons() {
        
        if let oldConstraint = trafficLightConstraints {
            NSLayoutConstraint.deactivate(oldConstraint)
        }

        let closeButton = view.window!.standardWindowButton(.closeButton)!
        let miniaturizeButton = view.window!.standardWindowButton(.miniaturizeButton)!
        let zoomButton = view.window!.standardWindowButton(.zoomButton)!
        
        // turn of auto resizing
        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        miniaturizeButton.translatesAutoresizingMaskIntoConstraints = false
//        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        
        // set button constraints
        let formatOption = NSLayoutFormatOptions.alignAllCenterY
        let edgePadding = NSNumber(value: 12.0)
        let trafficLightPadding = NSNumber(value: 6.0)
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(edgePadding)-[closeButton]-(trafficLightPadding)-[miniaturizeButton]-(trafficLightPadding)-[zoomButton]",
            options: formatOption,
            metrics: ["edgePadding":edgePadding, "trafficLightPadding":trafficLightPadding],
            views:["closeButton":closeButton, "miniaturizeButton":miniaturizeButton, "zoomButton":zoomButton]
        )
        
        let vEdgePadding = NSNumber(value: 6)
        let vConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-vEdgePadding-[closeButton]",
            options: formatOption,
            metrics: ["vEdgePadding":vEdgePadding],
            views: ["closeButton":closeButton])
        
        // save and activate constraint
        trafficLightConstraints = hConstraints + vConstraints
        //NSLayoutConstraint.activate(trafficLightConstraints!)
        //return
        view.addSubview(closeButton)
        
        //closeButton.superview?.addSubview(closeButtonShadowView)
        // set shadow constraint
        //let constraints = makeEqualConstraint(forView: closeButtonShadowView, toView: closeButton)
        let constraints = makeEqualConstraint(forView: closeButton, toView: closeButtonShadowView)
        
        // activate constraints
        NSLayoutConstraint.activate(constraints)
        
        // save it to maintain strong pointer
        buttonShadowConstraints = constraints

 
    }
    
    struct SomeError: Error {
        
    }
    
    override func viewDidLoad() {
        
    }
    
    func makeEqualConstraint(forView: NSView, toView: NSView) -> [NSLayoutConstraint] {
        let xPosConstraint = NSLayoutConstraint(
            item: forView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: toView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
        
        let yPosConstraint = NSLayoutConstraint(
            item: forView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: toView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        let widthConstraint = NSLayoutConstraint(
            item: forView,
            attribute: .width,
            relatedBy: .equal,
            toItem: toView,
            attribute: .width,
            multiplier: 1.0,
            constant: 0)
        
        let heightConstraint = NSLayoutConstraint(
            item: forView,
            attribute: .height,
            relatedBy: .equal,
            toItem: toView,
            attribute: .height,
            multiplier: 1.0,
            constant: 0)
        
        return [
            xPosConstraint,
            yPosConstraint,
            widthConstraint,
            heightConstraint
        ]
    }
    
    func makeConstraints(forButton: NSButton, toView: NSView) -> [NSLayoutConstraint] {
        return makeEqualConstraint(forView: forButton, toView: toView)
        //return makeEqualConstraint(forView: toView, toView: forButton)
    }
    
    
}

