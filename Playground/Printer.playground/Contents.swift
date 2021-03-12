import Cocoa

extension Array {
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

public class Printer: CustomDebugStringConvertible {
    fileprivate let pmPrinter: PMPrinter?
    
    public init(pmPrinter: PMPrinter) {
        self.pmPrinter = pmPrinter
        PMRetain(UnsafeRawPointer(pmPrinter))
    }
    deinit {
        if pmPrinter != nil {
            PMRelease(UnsafeRawPointer(pmPrinter))
        }
    }
    
    public var debugDescription: String {
        return "Printer \(pmPrinter)"
    }
}

public func getAvailablePrinters() -> [Printer] {
    var ptr: Unmanaged<CFArray>? = nil
    guard PMServerCreatePrinterList(nil, &ptr) == 0,
          let array = ptr?.takeRetainedValue(),
          let printers = Array<PMPrinter>.fromCFArray(array) else {
        return []
    }

    return printers.map({ return Printer(pmPrinter: $0) })
}

let concurrentQueue = DispatchQueue(label: "printer.concurrent.queue", attributes: .concurrent)

for i in 0...10 {
    concurrentQueue.async {
        for p in getAvailablePrinters() {
            print("task \(i) - \(p)")
        }
    }
}


