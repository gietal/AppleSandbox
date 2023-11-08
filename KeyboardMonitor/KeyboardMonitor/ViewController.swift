//
//  ViewController.swift
//  KeyboardMonitor
//
//  Created by gietal on 5/12/23.
//

import Cocoa
import Carbon

func stringFromEvent(event: CGEvent) -> String? {

//    var keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
//    let layoutData = unsafeBitCast(TISGetInputSourceProperty(keyboard, kTISPropertyUnicodeKeyLayoutData), to: CFData.self)
//    let layout = unsafeBitCast(CFDataGetBytePtr(layoutData), to: UnsafePointer<UCKeyboardLayout>.self)

    var chars = [UniChar](repeating: 0, count: 256)
    var charsCount = 0

    event.keyboardGetUnicodeString(maxStringLength: chars.count, actualStringLength: &charsCount, unicodeString: &chars)
    if charsCount > 0 {
        let cfString = CFStringCreateWithCharacters(kCFAllocatorDefault, chars, charsCount)
        let nsString = NSString(characters: chars, length: charsCount)
        return String(nsString)
//        let cString = CFStringGetCString(cfString, <#T##buffer: UnsafeMutablePointer<CChar>!##UnsafeMutablePointer<CChar>!#>, <#T##bufferSize: CFIndex##CFIndex#>, <#T##encoding: CFStringEncoding##CFStringEncoding#>)(cfString, kCFStringEncodingASCII)
//        let swiftString = String(cString: cString!)
//        return swiftString
    }
    return nil
}

func eventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let vc = Unmanaged<ViewController>.fromOpaque(userInfo!).takeUnretainedValue()
    
    if event.type == .keyDown {
        if let str = stringFromEvent(event: event) {
            vc.textField.stringValue += str
        }
    }
    return Unmanaged.passUnretained(event)
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        textField.stringValue = ""
    }
    
    
    @IBOutlet weak var textField: NSTextField!
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    override func awakeFromNib() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) //| (1 << CGEventType.keyUp.rawValue)
        let eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .tailAppendEventTap,
            options: .listenOnly,
            eventsOfInterest: CGEventMask(eventMask),
            callback: eventTapCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque())
        
        let runloopSource = CFMachPortCreateRunLoopSource(nil, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runloopSource, .commonModes)
    }


}

