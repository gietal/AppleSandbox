import Cocoa
import Carbon

var str = "Hello, playground"
let inputSource = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
let keyboardLayout = TISCopyCurrentKeyboardLayoutInputSource().takeRetainedValue()

var layout = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
Unmanaged<NSString>.fromOpaque(layout!).takeUnretainedValue() as String

layout = TISGetInputSourceProperty(keyboardLayout, kTISPropertyInputSourceID)
Unmanaged<NSString>.fromOpaque(layout!).takeUnretainedValue() as String

let keyboardType = LMGetKbdType()
let layoutType = KBGetLayoutType(Int16(keyboardType))
let keyboardANSI = UInt32(kKeyboardANSI) == layoutType
let keyboardISO = UInt32(kKeyboardISO) == layoutType
let keyboardJIS = UInt32(kKeyboardJIS) == layoutType
                        
//TISGetInputSourceProperty
asdad
