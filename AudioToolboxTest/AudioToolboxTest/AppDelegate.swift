//
//  AppDelegate.swift
//  AudioToolboxTest
//
//  Created by Gieta Laksmana on 11/7/23.
//

import Cocoa
import AudioToolbox

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    var isRecording = false
    var inputDevice: AudioToolboxInputDevice!
    
    @IBOutlet weak var recordButton: NSButton!
    @IBAction func onRecordButtonPressed(_ sender: NSButton) {
        // toggle
        isRecording = !isRecording
        
        if isRecording {
            recordButton.stringValue = "Stop"
            inputDevice = AudioToolboxInputDevice()
            try? inputDevice.open()
        } else {
            recordButton.stringValue = "Record"
            inputDevice.close()
            inputDevice = nil
        }
        recordButton.needsDisplay = true
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

