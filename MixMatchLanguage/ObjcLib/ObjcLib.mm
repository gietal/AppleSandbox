//
//  ObjcLib.m
//  ObjcLib
//
//  Created by gietal-dev on 5/10/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

#import "ObjcLib.h"
#include "../CppLib/CppLib.hpp"

@implementation ObjcClass
    {
        CppClass cppClass;
    }
    
    -(void)doStuff {
        printf("hello from objc static lib\n");
        cppClass.DoStuff();
    }
    
@end
