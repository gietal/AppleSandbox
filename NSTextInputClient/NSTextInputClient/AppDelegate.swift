//
//  AppDelegate.swift
//  NSTextInputClient
//
//  Created by gietal on 3/11/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

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
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: -
    // These are the 'delegate' functions to handle UI
    
    public func clearPendingText() {
        pendingTextLabel.stringValue = ""
    }
    
    public func updatePendingText(text: String, selectedRange: NSRange) {
        updatePendingTextUI(text: text, selectedRange: selectedRange)
        updatePendingText2(text: text, selectedRange: selectedRange)
    }
    
    public func sendText(text: String) {
//        sendTextToOutput(text: text)
        sendText2(text: text)
    }
    
    // MARK: first implementation local window
    public func updatePendingTextUI(text: String, selectedRange: NSRange) {
        pendingTextLabel.stringValue = text
        
        let attrString: NSMutableAttributedString = NSMutableAttributedString(attributedString: pendingTextLabel.attributedStringValue)
        
        if selectedRange.length == 0 {
            // underline everything
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        } else {
            // underline normal from 0 to markedRange.start
//            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, selectedRange.location))
            
            // underline thick from markedRange.start to markedRange.end
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: selectedRange)
            
            // underline normal from markedRange.end to end
//            let markedRangeEnd = selectedRange.location + selectedRange.length
//            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(markedRangeEnd, text.count - markedRangeEnd))
        }
        
        pendingTextLabel.attributedStringValue = attrString
    }
    
    public func sendTextToOutput(text: String) {
        resultTextLabel.stringValue += text
    }
    
    // MARK: second implementation, output window
    var sentPendingText: String? = nil
    public func updatePendingText2(text: String, selectedRange: NSRange) {
        // delete the previously selected text
        if let sentText = sentPendingText {
            let commonPrefix = sentText.commonPrefix(with: text, options: .literal)
            if commonPrefix == text {
                // do nothing, user is only changing the selected IME range
                return
            }
            
            // otherwise user changed the text with the IME
            // so we must update the remote's text as well
            
            // delete up to the common prefix
            sendDelete(count: sentText.count - commonPrefix.count)
            
            // then send the new text to the output, starting from the end of the common prefix
            let sendIndex = text.index(text.startIndex, offsetBy: commonPrefix.count)
            sendTextToOutput(text: String(text[sendIndex...]))
            
        } else {
            // we haven't sent any text yet to the output, just send everything
            sendTextToOutput(text: text)
        }
        
        // update the pending text on the remote session
        sentPendingText = text
    }
    
    public func sendText2(text: String) {
        if let sentText = sentPendingText {
            // delete the sent text first
            sendDelete(count: sentText.count)
        }
        
        // send everything to output
        sendTextToOutput(text: text)
        
        sentPendingText = nil
    }
    
    public func sendDelete(count: Int) {
        resultTextLabel.stringValue = String(resultTextLabel.stringValue.dropLast(count))
    }
}

extension NSRange {
    static let invalid: NSRange = NSMakeRange(NSNotFound, 0)
}

// MARK: - TexInputView implementation
// This is the main View class that will take keyboard input and handle IME

class TextInputView: NSView, NSTextInputClient {
    var pendingText: String? = nil
    var pendingMarkedRange: NSRange = NSRange.invalid
    var pendingSelectedRange: NSRange = NSRange.invalid
    var lastIMEWindowRect = NSRect(x: 500, y: 500, width: 0, height: 0)
    
    var lastCaretPosition = CGPoint(x: 500, y: 500)
    var lastIMEWindowPos = CGPoint.zero
    var imeWindowVisible = false
    
    var imeWindow: NSWindow? {
        return NSApp.windows.first(where:{$0.className == "NSPanelViewBridge"})
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidOrderOnScreen(_:)), name: NSNotification.Name("NSWindowDidOrderOnScreenAndFinishAnimatingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidOrderOffScreen(_:)), name: NSNotification.Name("NSWindowDidOrderOffScreenAndFinishAnimatingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidMove(_:)), name: NSWindow.didMoveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillMove(_:)), name: NSWindow.willMoveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResize(_:)), name: NSWindow.didResizeNotification, object: nil)
    }

    @objc func windowDidOrderOnScreen(_ notification: Notification ) {
        guard let window = notification.object as? NSWindow else {
            return
        }
        
        if window.className == "NSPanelViewBridge" {
            imeWindowVisible = true
            lastIMEWindowPos = window.frame.origin
            print("987987 IME window shows up. frame: \(window.frame)")
//            windowToCaretOffset = CGPoint(x: lastCaretPosition.x - window.frame.origin.x, y: lastCaretPosition.y - window.frame.origin.y)
        }
    }

    @objc func windowDidOrderOffScreen(_ notification: Notification ) {
        guard let window = notification.object as? NSWindow else {
            return
        }
        
        if window.className == "NSPanelViewBridge" {
            imeWindowVisible = false
            print("987987 IME window closed. frame: \(window.frame)")
            
        }
    }

    @objc func windowWillMove(_ notification: Notification ) {
        guard let window = notification.object as? NSWindow else {
            return
        }
        
        if window.className == "NSPanelViewBridge" {
//            // get how much the window moved since last time
//            let offset = CGPoint(x: window.frame.origin.x - lastIMEWindowPos.x, y: window.frame.origin.y - lastIMEWindowPos.y)
//
//            // cache the new position
//            lastIMEWindowPos = window.frame.origin
//
//            // offset the caret position
            print("987987 IME window will move. frame: \(window.frame)")
//            lastCaretPosition = CGPoint(x: window.frame.origin.x + windowToCaretOffset.x, y: window.frame.origin.y + windowToCaretOffset.y)
//            windowToCaretOffset = CGPoint(x: lastCaretPosition.x - window.frame.origin.x, y: lastCaretPosition.y - window.frame.origin.y)
        }
    }
    
    @objc func windowDidMove(_ notification: Notification ) {
        guard let window = notification.object as? NSWindow else {
            return
        }
        
        if window.className == "NSPanelViewBridge" {
            
            print("987987 IME window moved. frame: \(window.frame)")
//            lastCaretPosition = CGPoint(x: window.frame.origin.x + windowToCaretOffset.x, y: window.frame.origin.y + windowToCaretOffset.y)
//            windowToCaretOffset = CGPoint(x: lastCaretPosition.x - window.frame.origin.x, y: lastCaretPosition.y - window.frame.origin.y)
            
            // get how much the window moved since last time
            let offset = CGPoint(x: window.frame.origin.x - lastIMEWindowPos.x, y: window.frame.origin.y - lastIMEWindowPos.y)
            
            // cache the new position
            lastIMEWindowPos = window.frame.origin
            
            // offset the caret position
            lastCaretPosition = CGPoint(x: lastCaretPosition.x + offset.x, y: lastCaretPosition.y + offset.y)
        }
    }
    
    @objc func windowDidResize(_ notification: Notification ) {
        guard let window = notification.object as? NSWindow else {
            return
        }
        
        if window.className == "NSPanelViewBridge" {
            print("987987 IME window resized. frame: \(window.frame)")
            lastIMEWindowPos = window.frame.origin
//            lastCaretPosition = CGPoint(x: window.frame.origin.x + windowToCaretOffset.x, y: window.frame.origin.y + windowToCaretOffset.y)
//            windowToCaretOffset = CGPoint(x: lastCaretPosition.x - window.frame.origin.x, y: lastCaretPosition.y - window.frame.origin.y)
        }
    }
    
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
    
//    override func insertNewline(_ sender: Any?) {
//        print("insertNewLine")
//    }
    
    // finished text done through IME input will go here after going through setMarkedText several times.
    // English letters that doesn't need IME will go here directly
    func insertText(_ string: Any, replacementRange: NSRange) {
        AppDelegate.instance().clearPendingText()
        guard let insertedText = toString(anyStr: string) else {
            print("insertText nil")
            return
        }
        print("insertText: \(insertedText), replacementRange: \(replacementRange)")
        
        // english letters goes straight here without going to setMarkedText
        // so we need to send the insertedText, not pendingText
        pendingText = nil
        AppDelegate.instance().sendText(text: insertedText)
        
        // reset values and notify input context of changes
        unmarkText()
        inputContext!.invalidateCharacterCoordinates()
        
        // set at the end of result if exist
        pendingSelectedRange = NSMakeRange(AppDelegate.instance().resultTextLabel.stringValue.count, 0)
    }
    
    // letters that needed IME will go here, even character such as é, the ´ will be sent here
    // the typed text are in a 'pending' state, waiting for further input.
    // once input is done, insertText will be called with the finished text
    func setMarkedText(_ string: Any, selectedRange: NSRange, replacementRange: NSRange) {
        guard let markedText = toString(anyStr: string) else {
            print("setMarkedText nil")
            return
        }
        print("setMarkedText: \(markedText), selectedRange: \(selectedRange), replacementRange: \(replacementRange)")
        pendingText = markedText
//        pendingMarkedRange = NSMakeRange(0, markedText.count)
//        pendingSelectedRange = selectedRange
        pendingMarkedRange = NSMakeRange(attributedString().length, markedText.count)
        pendingSelectedRange = NSMakeRange(pendingMarkedRange.location + selectedRange.location, selectedRange.length) // whats the loc doing??
        AppDelegate.instance().updatePendingText(text: pendingText!, selectedRange: selectedRange)
        
        // notify input context
        inputContext!.invalidateCharacterCoordinates()
    }
    
    func unmarkText() {
        if let actualText = pendingText {
            AppDelegate.instance().sendText(text: actualText)
        }
        
        // reset values
        pendingText = nil
        pendingMarkedRange = NSRange.invalid
//        pendingSelectedRange = NSRange.invalid
        
        // notify input context
        inputContext!.discardMarkedText()
//        inputContext!.invalidateCharacterCoordinates()
    }
    
    // This should return the range currently selected for replacement by IME candidate window
    // this value is simply the 'selectedRange' parameter from setMarkedText
    func selectedRange() -> NSRange {
        print("selectedRange: \(pendingMarkedRange)")
        return pendingSelectedRange
    }
    
    // This should return the range of the currently pending text
    // so something like: NSRange(0, length of pending text)
    func markedRange() -> NSRange {
        print("markedRange: \(pendingMarkedRange)")
        return pendingMarkedRange
    }
    
    // Return if we have a pending text
    func hasMarkedText() -> Bool {
        return pendingText != nil
    }
    
    func attributedSubstring(forProposedRange range: NSRange, actualRange: NSRangePointer?) -> NSAttributedString? {
        return nil
    }
    
    func validAttributesForMarkedText() -> [NSAttributedString.Key] {
        return []
    }
    
    // Return the box where the IME candidate window should pop up for a given selected range of character
    // The Rect should be on the screen coordinate
    func firstRect(forCharacterRange range: NSRange, actualRange: NSRangePointer?) -> NSRect {
//        if range.location == NSNotFound {
//            return NSRect.zero
//        }
//        actualRange?.pointee = range
        
//        let pendingTextLabel = AppDelegate.instance().pendingTextLabel!
//        var markedTextRect = pendingTextLabel.frame
//        markedTextRect.origin = NSPoint(x: markedTextRect.origin.x + CGFloat(range.location) * 5.0, y: markedTextRect.origin.y)
//        markedTextRect.size = NSSize(width: 5, height: markedTextRect.height)
//        let myViewRect = pendingTextLabel.convert(markedTextRect, to: self)
//        let screenRect = self.window!.convertToScreen(myViewRect)
//        print("firstRect for range: \(range), rect: \(screenRect)")
//        return screenRect
        
        print("987987 firstRect needed. imeWindowVisible: \(imeWindowVisible)")
        return NSRect(origin: lastCaretPosition, size: CGSize(width: 1, height: 0))
//        return NSRect(x: 500, y: 500, width: 10, height: 10)
        
        
        
//        print("987987 firstRect IME for range: \(range), rect: \(lastIMEWindowRect)")
//        return NSRect(origin: lastIMEWindowRect.origin, size: NSSize(width: 0, height: 0))
    }
    
    func characterIndex(for point: NSPoint) -> Int {
        print("characterIndex for point: \(point)")
        return 0
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        print("becomeFirstResponder")
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
//        if event.keyCode == 0x24{
//            // enter key
//            inputContext?.c
//            return
//        }
        

//        inputContext!.invalidateCharacterCoordinates()
//        if let imeWindow = imeWindow {
//            // we want the position of the top left
//            let oldFrame = lastIMEWindowRect
//            var newFrame = imeWindow.frame
//            if newFrame.origin.x == oldFrame.origin.x - 8 && oldFrame.origin.y == newFrame.origin.y {
//                // assume this was due to selecting a longer text and the window expanded automatically
//                // set the position to be the old frame
//                newFrame.origin = oldFrame.origin
//            } else {
//                newFrame.origin = NSPoint(x: newFrame.origin.x, y: newFrame.origin.y + newFrame.height + 4)
//            }
//            lastIMEWindowRect = newFrame
//            print("987987 updated IME window to \(lastIMEWindowRect)")
//        }
//
        // is there a way to not have to double click the enter key?
        if !inputContext!.handleEvent(event) {
            // not handled by the IME
            print("unhandled event \(event.keyCode)")
        }
    }
    
    override func doCommand(by selector: Selector) {
        super.doCommand(by: selector)
    }
    
    func attributedString() -> NSAttributedString {
        print("attributedString: \(AppDelegate.instance().resultTextLabel.stringValue)")
        return NSAttributedString(string: AppDelegate.instance().resultTextLabel.stringValue)
//        return NSAttributedString()
    }
}

