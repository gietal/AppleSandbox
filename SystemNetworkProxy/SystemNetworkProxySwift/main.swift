//
//  main.swift
//  SystemNetworkProxySwift
//
//  Created by gietal on 4/8/20.
//  Copyright © 2020 gietal. All rights reserved.
//

import Foundation

struct SystemNetworkProxyConfig {
    var host: String = ""
    var port: Int = 0
    var username: String = ""
    var password: String = ""
    var fullAddress: String {
        return "\(host):\(port)"
    }
}

public class SystemNetworkProxy {
    static func getProxies(for url: URL) -> [SystemNetworkProxyConfig] {
        let proxySettings = CFNetworkCopySystemProxySettings()!.takeRetainedValue()
        let proxyArray: NSArray = CFNetworkCopyProxiesForURL(url as CFURL, proxySettings).takeRetainedValue()
        print("proxy settings:")
        print(proxySettings)
        print("system wide proxy setting:")
        print(proxyArray)
        return resolveProxies(proxies: proxyArray, targetUrl: url)
    }
    
    static private func resolveProxies(proxies: NSArray, targetUrl: URL) -> [SystemNetworkProxyConfig] {
        var output = [SystemNetworkProxyConfig]()
        for item in proxies {
            let proxyProp = item as! NSDictionary
            if let configs = resolveProxy(props: proxyProp, targetUrl: targetUrl) {
                output.append(contentsOf: configs)
            }
        }
        return output
    }
    
    static private func resolveProxy(props: NSDictionary, targetUrl: URL) -> [SystemNetworkProxyConfig]? {
        var anyval: Any? = props[kCFProxyTypeKey]
        if anyval == nil {
            return nil
        }
        let type = anyval as! CFString
        
        // skip none
        if type == kCFProxyTypeNone {
            return nil
        }
        
        // special case PAC
        if type == kCFProxyTypeAutoConfigurationURL {
            anyval = props[kCFProxyAutoConfigurationURLKey]
            if anyval == nil {
                return nil
            }
            let pacUrl = anyval as! URL
            
            return resolveProxies(proxies: resolvePAC(url: pacUrl, targetUrl: targetUrl), targetUrl: targetUrl)
        }
        
        // skip non-http/https
        if !(type == kCFProxyTypeHTTP || type == kCFProxyTypeHTTPS) {
            return nil
        }
        
        // grab host, port, username, pwd
        anyval = props[kCFProxyHostNameKey]
        if anyval == nil {
            // no hostname
            return nil
        }
        let hostname = anyval as! String
        var port = 0
        
        anyval = props[kCFProxyPortNumberKey]
        if anyval != nil {
            port = anyval as! Int
        } else if type == kCFProxyTypeHTTP {
            port = 80
        } else if type == kCFProxyTypeHTTPS {
            port = 443
        }
        
        var username = ""
        var password = ""
        
        if let val = props[kCFProxyUsernameKey] {
            username = val as! String
        }
        if let val = props[kCFProxyPasswordKey] {
            password = val as! String
        }
        
        
        return [SystemNetworkProxyConfig(host: hostname, port: port, username: username, password: password)]
    }
    
    static private func resolvePAC(url: URL, targetUrl: URL) -> NSArray {
        var output = NSArray()
        
        // only support valid scheme url
        if url.scheme == nil {
            return output
        }
        
        var fileContent = ""
        
        // dont support file url
        if url.isFileURL {
            do {
                fileContent = try String(contentsOf: url, encoding: .ascii)
                
            } catch {
                print("error reading local pac file: \(error)")
            }
        } else {
            // todo: change to promises
            let sem = DispatchSemaphore(value: 0)
            
            // start the download
            print("start downloading pac from \(url)")
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print("finished downloading pacfile content:")
                defer {
                    sem.signal()
                }
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
                
                fileContent = strData
                
            }).resume()
            
            sem.wait(timeout: DispatchTime.distantFuture)
        }
        
        if fileContent.isEmpty {
            print("file content is empty")
            return output
        }
        print(fileContent)
        print("processing pac")
        
        var pacError: Unmanaged<CFError>?
        guard let pacProxies: NSArray = CFNetworkCopyProxiesForAutoConfigurationScript(fileContent as CFString, targetUrl as CFURL, &pacError)?.takeRetainedValue() else {
            if let err = pacError?.takeUnretainedValue() {
                print("error executing pac script: \(err)")
            }
            return output
        }
        output = pacProxies
        print("finished processing pac")
        
        print("pac file proxies:")
        for item in output {
            let proxyProp = item as! NSDictionary
            print(proxyProp)
        }
        
        return output
    }
}

let targetUrl = NSURL(string: "https://www.microsoft.com")!
let bypassUrl = NSURL(string: "https://www.example.com")!
let bypassUrl2 = NSURL(string: "https://www.bypass.com")!
let proxies = SystemNetworkProxy.getProxies(for: targetUrl as URL)

print("proxies:")
for p in proxies {
    print(p)
}
