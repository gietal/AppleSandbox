//: Playground - noun: a place where people can play

import Cocoa
import Carbon

func getSource() -> Unmanaged<TISInputSource>! {
    return nil
    return TISCopyCurrentKeyboardInputSource()
}

func main() {
    var str = "Hello, playground"
    guard let source = getSource(),
        let layout = TISGetInputSourceProperty(source.takeUnretainedValue(), kTISPropertyInputSourceID),
        layout != nil else {
            print ("nil")
            return
    }
    
    let layoutName = Unmanaged<NSString>.fromOpaque(layout).takeUnretainedValue() as String
    print( layoutName)

}

main()