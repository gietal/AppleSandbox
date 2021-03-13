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
    
    private func getIntersectionRange(attrString: NSAttributedString, range: NSRange) -> NSRange? {
        // starts outside the range
        if range.location == NSNotFound || range.location >= attrString.length || range.location < 0 {
            return nil
        }
        
        // clip
        let lowRange = max(range.location, 0)
        let highRange = min(range.location + range.length, attrString.length)
        
        return NSMakeRange(lowRange, highRange - lowRange)
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
            return NSMakeRange(pt.count, 0)
        }
        return NSMakeRange(0, 0)
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
        print("attributedSubstring proposedRange: \(range)")
        let pendingTextAttrStr = AppDelegate.instance().pendingTextLabel.attributedStringValue
        if let adjustedRange = getIntersectionRange(attrString: pendingTextAttrStr, range: range) {
            actualRange?.pointee = adjustedRange
            return pendingTextAttrStr.attributedSubstring(from: adjustedRange)
        }
        
        return nil
    }
    
    func validAttributesForMarkedText() -> [NSAttributedString.Key] {
        return [.markedClauseSegment, .glyphInfo, .underlineStyle]
    }
    
    func firstRect(forCharacterRange range: NSRange, actualRange: NSRangePointer?) -> NSRect {
        // this gives back the
        let pendingTextLabel = AppDelegate.instance().pendingTextLabel!
        let markedTextRect = pendingTextLabel.attributedStringValue.attributedSubstring(from: range).boundingRect(with: pendingTextLabel.frame.size, options: [])
        let myViewRect = pendingTextLabel.convert(markedTextRect, to: self)
        let screenRect = self.window!.convertToScreen(myViewRect)
        
        print("firstRect for range: \(range)")
        return screenRect
    }
    
    func attributedString() -> NSAttributedString {
        return AppDelegate.instance().pendingTextLabel.attributedStringValue
    }
    
//    func baselineDeltaForCharacter(at anIndex: Int) -> CGFloat {
//        let pendingTextLabel = AppDelegate.instance().pendingTextLabel!
//        let originRect = pendingTextLabel.attributedStringValue.boundingRect(with: pendingTextLabel.frame.size, options: [])
//        let indexRect = pendingTextLabel.attributedStringValue.attributedSubstring(from: NSMakeRange(anIndex, 1)).boundingRect(with: pendingTextLabel.frame.size, options: [])
//        return CGFloat(1 * anIndex)
//
//    }
    
    
    
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

