import Cocoa
import CFNetwork


let proxySettings = CFNetworkCopySystemProxySettings()!.takeUnretainedValue()
let targetUrl = NSURL(string: "https://www.microsoft.com")!
let bypassUrl = NSURL(string: "https://www.example.com")!
let bypassUrl2 = NSURL(string: "https://www.bypass.com")!
let proxyArray: NSArray = CFNetworkCopyProxiesForURL(targetUrl as CFURL, proxySettings).takeUnretainedValue()


for item in proxyArray {
    let proxyProp = item as! NSDictionary
    if (proxyProp[kCFProxyTypeKey] as! CFString) == kCFProxyTypeNone {
        print("none")
    }
    print(proxyProp)
}

let pacFileUrl = URL(string: "https://raw.githubusercontent.com/gietal/AppleSandbox/master/SystemNetworkProxy/SystemNetworkProxy/sample.pac")!
let session = URLSession.shared
let urlTask = session.dataTask(with: pacFileUrl, completionHandler: { (data, response, error) in
    if let error = error {
        print("error: \(error)")
        return
    }
    
    guard let response = response as? HTTPURLResponse else {
        print("no response")
        return
    }
    
    if response.statusCode != 200 {
        print("response status is not 200, but \(response.statusCode)")
        return
    }
    
    guard let data = data else {
        print("no data")
        return
    }
    
    guard let strData = String(bytes: data, encoding: String.Encoding.ascii) else {
        print("invalid pac file")
        return
    }
    
    print(strData)
    
    var pacError: CFError?
    guard let pacProxies: NSArray = CFNetworkCopyProxiesForAutoConfigurationScript(strData as CFString, targetUrl as CFURL, nil)?.takeRetainedValue() else {
        return
    }
    print("pac file proxies:")
    for item in pacProxies {
        let proxyProp = item as! NSDictionary
        print(proxyProp)
    }
})
urlTask.resume()

