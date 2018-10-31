//
//  main.m
//  FontCheckerObjc
//
//  Created by gietal-dev on 15/10/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Appkit/Appkit.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        for( int i = 0; i < 100; ++i) {
            NSFont* f = [NSFont systemFontOfSize:i];
            if (f == nil) {
                NSLog(@"systemFont size: %d is null", i);
                continue;
            }
            SEL selector = NSSelectorFromString(@"_sharedFontInstanceInfo");
            id sharedFontInstanceInfo = [f performSelector:selector];
            if (sharedFontInstanceInfo == nil) {
                NSLog(@"systemFont size: %d has null _sharedFontInstanceInfo", i);
                continue;
            }
            
            selector = NSSelectorFromString(@"_platformFont");
            id platformFont = [sharedFontInstanceInfo performSelector:selector];
            if (platformFont == nil) {
                NSLog(@"systemFont size: %d has null _platformFont", i);
                continue;
            }
            
            NSLog(@"size: %d, %@", i, [f description]);
        }
        
        
    }
    return 0;
}
