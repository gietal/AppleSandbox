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

void create_local_port(void)
{
    CFStringRef port_name = CFSTR("DTT6RZZAQ.com.gietal.sandbox.group.port.server");
    CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault, port_name, &callback, NULL, NULL);
    return;
    CFMessagePortSetDispatchQueue(port, dispatch_get_main_queue());
}

void create_remote_port(void)
{
    CFStringRef port_name = CFSTR("DTT6RZZAQ.com.gietal.sandbox.group.port.client");
    CFMessagePortRef port = CFMessagePortCreateRemote(kCFAllocatorDefault, port_name);
}

int main(int argc, const char * argv[]) {
    create_local_port();
    return NSApplicationMain(argc, argv);
}
