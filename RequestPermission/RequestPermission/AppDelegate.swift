//
//  AppDelegate.swift
//  RequestPermission
//
//  Created by gietal on 6/19/19.
//  Copyright © 2019 gietal. All rights reserved.
//

import Cocoa
import AVFoundation

extension AVAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .authorized:
            // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            return "authorized"
        case .denied:
            // The user has explicitly denied permission for media capture.
            return "denied"
        case .notDetermined:
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            return "undetermined"
        case .restricted:
            // The user is not allowed to access media capture devices.
            return "restricted"
        @unknown default:
            return "unknown"
        }
    }
    
    
}
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var micAccessLabel: NSTextField!
    @IBOutlet weak var camAccessLabel: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        updateAccessLabel()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func updateAccessLabel()
    {
        DispatchQueue.main.async {
            self.micAccessLabel.stringValue = AVCaptureDevice.authorizationStatus(for: .audio).description
            self.camAccessLabel.stringValue = AVCaptureDevice.authorizationStatus(for: .video).description
        }
    }


    @IBAction func openMic(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            print("microphone access granted: \(granted)")
            self.updateAccessLabel()
        }
    }
    @IBAction func openCamera(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            print("camera access granted: \(granted)")
            self.updateAccessLabel()
        }
    }
}

