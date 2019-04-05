//
//  AppDelegate.m
//  cppRegex
//
//  Created by gietal on 2/18/19.
//  Copyright © 2019 gietal. All rights reserved.
//

#import "AppDelegate.h"
#include <regex>
#include <string>

@interface NSString (Extension)
+(NSString*)stringWithStdString:(const std::string&)string;
+(NSString*)stringWithStdStringNilIfEmpty:(const std::string&)string;
-(std::string)stdStringValue;
@end

@implementation NSString (Extension)

+(NSString*)stringWithStdString:(const std::string&)string
{
    return [NSString stringWithCString:string.c_str()
                              encoding:NSUTF8StringEncoding];
}

+(NSString*)stringWithStdStringNilIfEmpty:(const std::string&)string
{
    if (string.empty())
    {
        return nil;
    }
    return [NSString stringWithStdString:string];
}

-(std::string)stdStringValue
{
    return [self cStringUsingEncoding:NSUTF8StringEncoding];
}
@end


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *outputTextField;
@property (weak) IBOutlet NSTextField *regexTextField;
@property (weak) IBOutlet NSTextField *inputTextField;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [_regexTextField setDelegate:self];
    [_inputTextField setDelegate:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (void)controlTextDidChange:(NSNotification *)notif {
    // upate the regex
    std::string regexString = [[_regexTextField stringValue] stdStringValue];
    std::string inputString = [[_inputTextField stringValue] stdStringValue];
    
    try {
        std::regex regex(regexString);
        
        std::string output;
        
        for (std::sregex_iterator iter = std::sregex_iterator(inputString.begin(), inputString.end(), regex); iter != std::sregex_iterator(); ++iter)
        {
            output += (*iter).str() + "\n";
        }
        
        [_outputTextField setStringValue:[NSString stringWithStdString:output]];
    } catch(const std::exception& e)
    {
        [_outputTextField setStringValue:[NSString stringWithUTF8String:e.what()]];
    }
    
}


@end
