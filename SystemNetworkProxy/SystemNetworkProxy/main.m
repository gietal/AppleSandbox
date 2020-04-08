//
//  main.m
//  SystemNetworkProxy
//
//  Created by gietal on 4/8/20.
//  Copyright © 2020 gietal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        CFDictionaryRef proxySettingMap = CFNetworkCopySystemProxySettings();
        
        CFURLRef url = CFURLCreateWithString(NULL, CFSTR("https://www.microsoft.com"), NULL);
        CFURLRef bypassedUrl = CFURLCreateWithString(NULL, CFSTR("https://www.bypass.com"), NULL);
        CFArrayRef proxyArray = CFNetworkCopyProxiesForURL(url, proxySettingMap);
        CFArrayRef bypassedProxyArray = CFNetworkCopyProxiesForURL(bypassedUrl, proxySettingMap);
        
//        CFNetworkCopyProxiesForAutoConfigurationScript(<#CFStringRef  _Nonnull proxyAutoConfigurationScript#>, url, NULL);
        return 0;
    }
    return 0;
}
