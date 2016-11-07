//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playgrounsdd"

var settings = NSUserDefaults(suiteName: "com.apple.trackpad")!

settings = NSUserDefaults.standardUserDefaults()

let dict = settings.dictionaryRepresentation()

settings.synchronize()


for k in settings.dictionaryRepresentation().keys {
    if
        //k.lowercaseString.containsString("trackpad") ||
        //k.lowercaseString.containsString("click") ||
        k.lowercaseString.containsString("mouse")
    {
        
        print("\(k): \(settings.integerForKey(k))")
    }
}

// 1 finger click ?

settings.integerForKey("com.apple.mouse.tapBehavior") // this is the 1 finger click

// right click
settings.integerForKey("com.apple.trackpad.enableSecondaryClick") // tap/click with 2 finger, will be 0 if click corner is selected
settings.integerForKey("com.apple.trackpad.trackpadCornerClickBehavior") // 1 - bottom left, 2 - bottom right, will be 0 if tap/click with 2 finger is selected

// quicklook
settings.integerForKey("com.apple.trackpad.threeFingerTapGesture")
settings.integerForKey("com.apple.trackpad.forceClick")

    // 3 finger drag
    settings.integerForKey("com.apple.trackpad.threeFingerDragGesture")

// if look up = true && using force click 1 finger. 
//   - trackpad.forceClick = 1
//   - trackpad.threeFingerTapGesture = 0

println