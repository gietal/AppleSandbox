//
//  main.swift
//  FontCheckerCLI
//
//  Created by gietal-dev on 15/10/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import AppKit

func check(font f: NSFont?, size: CGFloat) {
    guard let f = f else {
        print("ERROR font is nil for size: \(size)")
        return
    }
    
    print("size: \(size), font: \(f), matrix: \(f.matrix)")
    if f.matrix != nil {
        var matrixStr = "matrix = { "
        for i in 0..<6 {
            matrixStr += "\(f.matrix[i]), "
        }
        matrixStr.removeLast(2)
        matrixStr += " }"
        print("\(matrixStr)")
    } else {
        print("ERROR MATRIX IS NIL FOR SYSTEM FONT SIZE: \(size)")
    }
}
print("Checkin system font")
print()

for size in 1...200 {
    check(font: NSFont.systemFont(ofSize: CGFloat(size)), size: CGFloat(size))
}

for size in 1...200 {
    check(font: NSFont(name: "RDP MDL2 Assets", size: CGFloat(size)), size: CGFloat(size))
}
