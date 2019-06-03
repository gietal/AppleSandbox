//
//  main.m
//  ChildProcess
//
//  Created by gietal-dev on 6/3/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
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
