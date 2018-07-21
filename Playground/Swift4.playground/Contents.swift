//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let strList = ["bb", "aa", "cc"]

strList.sorted(by: <)

if let defaults = UserDefaults(suiteName: "com.gietal.sandbox.group") {
    defaults.set(123, forKey: "mySetting")
    
    defaults.value(forKey: "mySetting")
}


