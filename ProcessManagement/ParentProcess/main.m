//
//  main.m
//  ParentProcess
//
//  Created by gietal-dev on 6/3/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

CFDataRef callback(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info)
{
    NSLog(@"parent received message from child: %d", msgid);
    return NULL;
}

CFMessagePortRef gPort = nil;

void create_local_port(void)
{
    CFStringRef port_name = CFSTR("DTT6RZZAQ3.com.gietal.sandbox.group.port.server");
    CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault, port_name, &callback, NULL, NULL);
    if (port != nil) {
        NSLog(@"ParentProcess created port");
    } else {
        NSLog(@"ParentProcess failed to create port");
        return;
    }
    CFMessagePortSetDispatchQueue(port, dispatch_get_main_queue());
    gPort = port;
}

int main(int argc, const char * argv[]) {
    create_local_port();
    return NSApplicationMain(argc, argv);
}
