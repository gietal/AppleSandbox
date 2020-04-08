import Cocoa
import CFNetwork

let proxySettings = CFNetworkCopySystemProxySettings()!.takeUnretainedValue()
let url = NSURL(string: "https://www.microsoft.com")!
let proxyArray: NSArray = CFNetworkCopyProxiesForURL(url as CFURL, proxySettings).takeUnretainedValue()

for item in proxyArray {
    let proxyProp = item as! NSDictionary
    if (proxyProp[kCFProxyTypeKey] as! CFString) == kCFProxyTypeNone {
        print("none")
    }
    print(proxyProp)
}

