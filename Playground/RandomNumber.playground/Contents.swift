//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

print(str)

extension Float {
    
    public static func randomUniform(low: Float, high: Float) -> Float {
        // arc4random_uniform will return number from [0, UINT32_MAX - 1]
        let p = arc4random_uniform(UINT32_MAX)  // [0, UINT32_MAX - 1]
        let normalized = Float(p) / Float(UINT32_MAX - 1) // [0, 1]
        
        print(normalized)
        // lerp
        return (high - low) * normalized + low
        
    }
    
    
}

for i in 0...100 {
    Float.randomUniform(low: 0, high: 1)
}

let a = UINT32_MAX - 1
print(a)
print(UINT32_MAX)