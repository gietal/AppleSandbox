//
//  main.m
//  ChildProcess
//
//  Created by gietal-dev on 6/3/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

CFDataRef callback(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info) {
    NSLog(@"Child Process received message from parent: %d", msgid);
    return NULL;
}

bool createPort() {
    // DTT6RZZAQ.
    CFStringRef port_name = CFSTR("DTT6RZZAQ.com.gietal.sandbox.group.port.client");
    CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault, port_name, &callback, NULL, NULL);
    if (port == nil) {
        NSLog(@"Child Process, port creation failed, port == nil");
        return false;
    } else {
        NSLog(@"Child Process created local port");
    }
    CFMessagePortSetDispatchQueue(port, dispatch_get_main_queue());
    return true;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"Child process creating local port");
//        if (!createPort())
        {
            return -1;
        }
        NSLog(@"Child process counting to 10");
        
        int count = 1;
        while(count <= 10)
        {
            NSLog(@"Child process count: %d", count++);
            sleep(1);
        }
        
    }
    return 0;
}
