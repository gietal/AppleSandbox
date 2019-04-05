
var str = "Hello, playground"

var anyInt: Any = 123
var anyFloat: Any = 123.456
var anyBool: Any = false
var anyString: Any = "hello"

var actualUint: UInt = 444
var anyUint: Any = actualUint

"\(anyInt), \(anyFloat), \(anyBool), \(anyString)"

anyUint as? Int64
anyUint as? UInt8
anyUint as? UInt16
anyUint as? UInt32
anyUint as? UInt64
anyUint as? UInt

anyUint is Int64
anyUint is UInt8
anyUint is UInt16
anyUint is UInt32
anyUint is UInt64
anyUint is UInt

anyUint == 444
//UInt.IntegerLiteralType
//var bigInt: Int64 = 0
//switch anyUint {
//case as? UInt:
//    bigInt = 2
//    break
//default:
//    bigInt = -1
//}
//
//var anyobj: AnyObject = actualUint


//bigInt
