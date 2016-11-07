//
//  main.swift
//  xmlParser
//
//  Created by Gieta Laksmana on 8/10/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

print("Hello, World!")

let parser = XmlParser()

let workDir = NSFileManager.defaultManager().currentDirectoryPath
try parser.parse(workDir + "/res/ClipboardActionTransformations.xml", layout: "com.apple.keylayout.Dvorak")

/*
<layout name="default">
<transformations>
    <!-- Command+X to Control+X -->
        <transform>
<from command="1" key="X" />
    <to control="1" key="X" />
        </transform>
        <!-- Command+C to Control+C -->
            <transform>
<from command="1" key="C" />
    <to control="1" key="C" />
        </transform>
        <!-- Command+V to Control+V -->
            <transform>
<from command="1" key="V" />
    <to control="1" key="V" />
        </transform>
</transformations>
</layout>
 */