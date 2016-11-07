//
//  main.swift
//  cfarray
//
//  Created by Gieta Laksmana on 9/26/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

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

func testPrinter() -> [PMPrinter] {
    let kPMServerLocal: OpaquePointer? = nil
    var ptr: Unmanaged<CFArray>? = nil
    guard PMServerCreatePrinterList(kPMServerLocal, &ptr) == 0,
        let array = ptr?.takeRetainedValue(),
        let printers = Array<PMPrinter>.fromCFArray(array) else {
            return []
    }
    
    return printers
}

func getDisplayModes(_ displayId: CGDirectDisplayID) -> [CGDisplayMode] {
    guard let displayModes: [CGDisplayMode] = Array.fromCFArray(CGDisplayCopyAllDisplayModes(displayId, nil)) else {
        return []
    }
    return displayModes
}

func testCFArray() {
    let array: [Int] = [0, 1, 2, 3]
    var rawPointer: UnsafeRawPointer? = UnsafeRawPointer(array)
    let cfArray = withUnsafeMutablePointer(to: &rawPointer) { ppArray in
        CFArrayCreate(kCFAllocatorDefault, ppArray, array.count, nil)
    }
    
    
    
    let newArray: [Int]? = Array.fromCFArray(cfArray)
    print(newArray)
}


let printers = testCFArray()
print(printers)
