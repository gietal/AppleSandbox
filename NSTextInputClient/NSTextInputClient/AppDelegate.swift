//
//  AppDelegate.swift
//  NSTextInputClient
//
//  Created by gietal on 3/11/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSTextViewDelegate {

    public static func instance() -> AppDelegate {
        return NSApp.delegate as! AppDelegate
    }
    
    @IBOutlet var window: NSWindow!
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var textInputView: TextInputView!
    @IBOutlet var inputTextView: NSTextView!
    
    @IBOutlet weak var pendingTextLabel: NSTextField!
    @IBOutlet weak var resultTextLabel: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let fieldEditor = window.fieldEditor(true, for: nil) as? NSTextView {
//            fieldEditor.delegate = self
        }
//        inputTextView.delegate = self
//        inputTextView.becomeFirstResponder()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        print("shouldChangeTextIn range: \(affectedCharRange), replacement: \(replacementString ?? "")")
        return true
    }
    
    func textShouldEndEditing(_ textObject: NSText) -> Bool {
        print("textShouldEndEditing. current text: \(textObject.string)")
        return true
    }
    
    public func clearPendingText() {
        pendingTextLabel.stringValue = ""
    }
    public func updatePendingText(text: String, markedRange: NSRange) {
        pendingTextLabel.stringValue = text
        
        var attrString: NSMutableAttributedString = NSMutableAttributedString(attributedString: pendingTextLabel.attributedStringValue)
        
        if markedRange.length == 0 {
            // underline everything
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        } else {
            // underline normal from 0 to markedRange.start
//            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, markedRange.location))
            
            // underline thick from markedRange.start to markedRange.end
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: markedRange)
            
            // underline normal from markedRange.end to end
//            let markedRangeEnd = markedRange.location + markedRange.length
//            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(markedRangeEnd, text.count - markedRangeEnd))
        }
        
        pendingTextLabel.attributedStringValue = attrString
    }
    
    public func sendText(text: String) {
//        print("send text: \(text)")
        resultTextLabel.stringValue += text
    }
}

class TextInputView: NSView, NSTextInputClient {
    var pendingText: String? = nil
    var pendingMarkedRange: NSRange = NSMakeRange(NSNotFound, 0)
    
    private func toString(anyStr: Any) -> String? {
        if let str = anyStr as? String {
            return str
        } else if let attrStr = anyStr as? NSAttributedString {
            return attrStr.string
        }
        return nil
    }
    
    func insertText(_ string: Any, replacementRange: NSRange) {
        AppDelegate.instance().clearPendingText()
        guard let insertedText = toString(anyStr: string) else {
            print("insertText nil")
            return
        }
        print("insertText: \(insertedText), replacementRange: \(replacementRange)")
        pendingText = nil
        pendingMarkedRange = NSMakeRange(NSNotFound, 0)
        AppDelegate.instance().sendText(text: insertedText)
    }
    
    func setMarkedText(_ string: Any, selectedRange: NSRange, replacementRange: NSRange) {
        guard let markedText = toString(anyStr: string) else {
            print("setMarkedText nil")
            return
        }
        print("setMarkedText: \(markedText), selectedRange: \(selectedRange), replacementRange: \(replacementRange)")
        pendingText = markedText
        pendingMarkedRange = selectedRange
        AppDelegate.instance().updatePendingText(text: pendingText!, markedRange: pendingMarkedRange)
    }
    
    func unmarkText() {
        print("unmarkText")
        if let actualText = pendingText {
            AppDelegate.instance().sendText(text: actualText)
        }
        pendingText = nil
        pendingMarkedRange = NSMakeRange(NSNotFound, 0)
        inputContext?.discardMarkedText()
    }
    
    func selectedRange() -> NSRange {
        if let pt = pendingText {
            return NSMakeRange(0, pt.count)
        }
        return NSMakeRange(NSNotFound, 0)
    }
    
    func markedRange() -> NSRange {
        return pendingMarkedRange
    }
    
    func hasMarkedText() -> Bool {
        return pendingText != nil
    }
    
    func attributedSubstring(forProposedRange range: NSRange, actualRange: NSRangePointer?) -> NSAttributedString? {
        if pendingText == nil {
            return nil
        }
        actualRange?.pointee = range
        return NSAttributedString(string: pendingText!)
    }
    
    func validAttributesForMarkedText() -> [NSAttributedString.Key] {
        return []
    }
    
    func firstRect(forCharacterRange range: NSRange, actualRange: NSRangePointer?) -> NSRect {
//        NSRect(origin: CGPoint(x: 200, y: 400), size: CGSize(width: 200, height: 0))
        return NSRect.zero
    }
    
    func characterIndex(for point: NSPoint) -> Int {
        return 0
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        print("becomeFirstResponder")
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        inputContext?.handleEvent(event)
    }
    
    override func doCommand(by selector: Selector) {
        super.doCommand(by: selector)
    }
}

