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