//: Playground - noun: a place where people can play

import Cocoa
import AppKit

var str = "Hello, playground"

let mainScreen = NSScreen.main!
let frame = mainScreen.frame

let scale = mainScreen.backingScaleFactor

let retineFrame = NSRect(x: frame.minX, y: frame.minY, width: frame.width * scale, height: frame.height * scale)

// window.screen.backingscale
// notification when display changed
// backing property changed
