//
//  AppDelegate.swift
//  LaunchFromURL
//
//  Created by Gieta Laksmana on 7/8/18.
//  Copyright © 2018 Gieta Laksmana. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


open func applicationWillFinishLaunching(_ notification: Notification) {
    initializeURIOptions()
}

fileprivate func initializeURIOptions() {
    // register to listen to the url event
    let appleEventManager = NSAppleEventManager.shared()
    appleEventManager.setEventHandler(self, andSelector: #selector(handleGetURLEvent(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
}

@objc fileprivate func handleGetURLEvent(event: NSAppleEventDescriptor?, withReplyEvent replyEvent: NSAppleEventDescriptor?) {
    guard let event = event else {
        return
    }
    // our URL event is in this format:
    // myapp://param1=val1&param2=val2&paramN=valN
    
    // grab the query pairs, that is the pairs separated by '&'
    guard let paramDesc = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
        let url = NSURL(string: paramDesc),
        let queryPairs = url.query?.components(separatedBy: "&") else {
            return
    }
    
    // parse the key/value pair
    // querypairs is assumed to be in the form of "key=value"
    var settingPairs = [String: String]()
    for query in queryPairs {
        let kvp = query.components(separatedBy: "=")
        if kvp.count != 2 {
            continue
        }
        
        let key = kvp[0].lowercased()
        let value = kvp[1].lowercased()
        settingPairs[key] = value
    }
    
    // do stuff with settingPairs
}
    
}

