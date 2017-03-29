//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

func getOptional() -> Int! {
    return 1234
}

if let a = getOptional() {
    print(a.description)
} else {
    print("a is nil even if marked !!")
}

func optionalEqual(_ a: Int?, _ b: Int?) {
    print("\(a) == \(b): \(a == b)")
}

optionalEqual(0, 1)
optionalEqual(0, 0)
optionalEqual(0, nil)
optionalEqual(nil, nil)