//
//  XmlParser.swift
//  xmlParsing
//
//  Created by Gieta Laksmana on 8/10/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

public class XmlParser {
    
    public func parse(filename: String) {
        
        
    }
    let document = try NSXMLDocument(contentsOfURL: url, options: NSXMLNodeOptionsNone)
    let nodes = try document.nodesForXPath("/transformations/transform")
    let transformations = nodes.flatMap({ KeyCombinationTransformation(xmlNode: $0) })

    public func parseNode(xmlNode: NSXMLNode?) {
        guard let xmlElement = xmlNode as? NSXMLElement,
            let fromElement = xmlElement.elementForName("from"),
            let toElement = xmlElement.elementForName("to") {
                
                print("from: \(fromElement)")
                
        } else {
                return
        }

    }
    
}