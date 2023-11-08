import Cocoa
import Foundation
import Carbon

private func translateKeyEventToUnicode(keyCode: UInt16, modifierFlags: UInt16) -> Unicode.Scalar? {
    // get the current keyboard input source layout
    // we don't cache this because user could change their keyboard layout or input source language at runtime
    // though most people generally don't
    guard let inputSource = TISCopyCurrentKeyboardLayoutInputSource() else {
        print("[UNICODE] TISCopyCurrentKeyboardInputSource returned nil")
        return nil
    }
    
    // get the raw unicode keyboard layout CFData
    guard let rawKeyboardLayoutPointer = TISGetInputSourceProperty(inputSource.takeUnretainedValue(), kTISPropertyUnicodeKeyLayoutData) else {
        print("[UNICODE] kTISPropertyUnicodeKeyLayoutData property is nil")
        return nil
    }
    
    // get a pointer to the keyboard layout
    let cfDataKeyboardLayout = Unmanaged<CFData>.fromOpaque(rawKeyboardLayoutPointer).takeUnretainedValue()
    guard let keyboardLayoutPointer = UnsafeRawPointer(CFDataGetBytePtr(cfDataKeyboardLayout))?.bindMemory(to: UCKeyboardLayout.self, capacity: 1) else {
        print("[UNICODE] keyboardLayoutPointer is nil")
        return nil
    }
    
    // UCKeyTranslate documentation says that the max unicode char length could theoretically be 255
    // but we would rarely ever gets more than 4
    let maxUnicodeCharLength: Int = 4
    var realUnicodeCharLength: Int = 0
    
    // allocate a buffer to hold the generated unicode
    let unicodeChars = UnsafeMutablePointer<UniChar>.allocate(capacity: maxUnicodeCharLength)
    unicodeChars.assign(repeating: UniChar(integerLiteral: 0), count: maxUnicodeCharLength)
    
    // UCKeyTranslate documentation says to do this to get the modifier parameters:
    // modifierKeyState = ((EventRecord.modifiers) >> 8) & 0xFF;
    //
    // what it doesn't say is that EventRecord.modifiers is NOT NSEvent.modifierFlags
    // the EventRecord.modifiers should come from Carbon > HIToolbox/Events.h > modifiers flags
    // so here we have to map NSEvent's modifiers flags to Carbon's modifiers flags, THEN do the bitshift stuff
    let modifierKeyState: UInt32 = (UInt32(modifierFlags) >> 8) & 0xff
    var unicodeDeadKeyState: UInt32 = 0
    
    // translate the key event + keyboard layout + modifiers into a unicode (or not, in case of deadkey)
    var osstatus = UCKeyTranslate(keyboardLayoutPointer,
                                  keyCode,
                                  UInt16(kUCKeyActionDown),
                                  UInt32(modifierKeyState),
                                  UInt32(LMGetKbdType()),
                                  0,                        // options
                                  &unicodeDeadKeyState,
                                  maxUnicodeCharLength,
                                  &realUnicodeCharLength,
                                  unicodeChars)
    
    if osstatus != noErr {
        print("[UNICODE] UCKeyTranslate failed with osstatus: \(osstatus)")
        return nil
    }
    
    var isDeadKey = false
//    if realUnicodeCharLength == 0 {
//        // this is a dead key, the deadKey state is updated in this case
//        isDeadKey = true
//
//        // do another UCKeyTranslate with space key to generate the deadkey unicode character to see what the dead key is
//        // but use a temp dead key state so it wont modify the actual dead key state
//        var tempDeadKeyState = unicodeDeadKeyState
//        osstatus = UCKeyTranslate(keyboardLayoutPointer,
//                                  Keycode.space.rawValue,
//                                  UInt16(kUCKeyActionDown),
//                                  UInt32(0),                // no modifiers
//                                  UInt32(LMGetKbdType()),
//                                  0,                        // no options
//                                  &tempDeadKeyState,
//                                  maxUnicodeCharLength,
//                                  &realUnicodeCharLength,
//                                  unicodeChars)
//
//        if osstatus != noErr {
//            DDLogError("[UNICODE] UCKeyTranslate for deadkey failed with osstatus: \(osstatus)")
//            return nil
//        }
//    }
    
    // the key event generated a valid unicode
    let unicodeString = CFStringCreateWithCharacters(kCFAllocatorDefault, unicodeChars, realUnicodeCharLength) as String
    
//    return (isDeadKey, unicodeString.unicodeScalars.first!)
    return unicodeString.unicodeScalars.first!
}

let keycode: UInt16 = 0x00 // ansi A
translateKeyEventToUnicode(keyCode: keycode, modifierFlags: 0)
translateKeyEventToUnicode(keyCode: keycode, modifierFlags: UInt16(shiftKey))
translateKeyEventToUnicode(keyCode: keycode, modifierFlags: UInt16(alphaLock))
translateKeyEventToUnicode(keyCode: keycode, modifierFlags: UInt16(alphaLock | shiftKey))

shiftKey
shiftKeyBit
alphaLock
alphaLockBit
1 << shiftKeyBit
AAAA
AAAAAAAAAASDASDASDADASDASDASDASDASDASDASDASDASDASDASDASDASDASDASDASD
