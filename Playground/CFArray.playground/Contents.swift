//: Playground - noun: a place where people can play

import Foundation

var str = "Hello, playground"

public extension Array {
    public static func fromCFArray(_ array: CFArray?) -> Array<Element>? {
        guard let array = array else {
            return nil
        }
        var result = [Element]()
        let arrayCount = CFArrayGetCount(array)
        for i in 0..<arrayCount {
            let unmanagedObject = CFArrayGetValueAtIndex(array, i)
            let element = unsafeBitCast(unmanagedObject, to: Element.self)
            result.append(element)
        }
        return result
    }
}


var array: [Int] = [0, 1, 2, 3]
var rawPointer: UnsafeRawPointer? = UnsafeRawPointer(array)
let cfArray = withUnsafeMutablePointer(to: &rawPointer) { ppArray in
    CFArrayCreate(kCFAllocatorDefault, ppArray, array.count, nil)
}


print(array)
print(rawPointer)
