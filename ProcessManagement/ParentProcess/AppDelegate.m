//
//  AppDelegate.m
//  ParentProcess
//
//  Created by gietal-dev on 6/3/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)startProcessButtonPressed:(NSButton *)sender {
    NSBundle* bundle = [NSBundle mainBundle];
    if (bundle == nil) {
        NSLog(@"Parent Process: NSBundle mainBundle is nil.");
        return;
    }
    
    NSString* appName = [bundle pathForAuxiliaryExecutable:@"ChildProcess"];
    if (appName == nil) {
        NSLog(@"Parent Process: appName is nil.");
        return;
    }
    
    NSURL* appURL = [NSURL fileURLWithPath:appName];
    NSArray<NSString *>* args = @[];
    NSTask* task = [NSTask launchedTaskWithExecutableURL:appURL arguments:args error:nil terminationHandler:^(NSTask *terminatedTask) {
        NSLog(@"child process terminated with status: %d", terminatedTask.terminationStatus);
    }];
}

@end
