//
//  RdpMacTrace.m
//  RdCore-OSX
//
//  Created by Gieta Laksmana on 9/29/16.
//  Copyright © 2016 gietal. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CoreFoundation/CFString.h"

#include "wchar.h"
#include "wstrunsafe.h"

void foo(wchar_t const *pFormatString, va_list *params)
{
    unsigned char           outputBuffer[100];
    int length = vswprintf((wchar_t*)outputBuffer,
                           (size_t(123)),
                           (wchar_t*)pFormatString,
                           *params);
}

@interface asd : NSObject
{
    
}

@end

@implementation asd

@end
