//
//  XmlParser.swift
//  xmlParsing
//
//  Created by Gieta Laksmana on 8/10/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

public class XmlParser {
    
    public func parse(filename: String, layout: String) throws {
        let url = NSURL(fileURLWithPath: filename)
        let document = try NSXMLDocument(contentsOfURL: url, options: NSXMLNodeOptionsNone)
        
        // load regular
        try parseTransformationsNodes(document)
        
        // load layout specific
        try parseLayoutNodes(document, targetLayoutName: layout)
    }
    
    private func parseTransformationsNodes(root: NSXMLNode) throws {
        let nodes = try root.nodesForXPath("./transformations/transform")
        nodes.flatMap({ parseNode($0)})
    }
    

    public func parseNode(xmlNode: NSXMLNode?) {
        guard let xmlElement = xmlNode as? NSXMLElement,
            let fromElement = xmlElement.elementForName("from"),
            let toElement = xmlElement.elementForName("to") else {
                
                print("error parsing node")
                return
        }
        
        print("from: \(fromElement)")
        print("to: \(toElement)")
    }
    
    private func parseLayoutNodes(root: NSXMLNode, targetLayoutName: String) throws {
        let nodes = try root.nodesForXPath("./layouts/layout")
        var targetLayoutNode: NSXMLNode? = nil
        var defaultLayoutNode: NSXMLNode? = nil
        for n in nodes {
            guard let xmlElement = n as? NSXMLElement
                else {
                    print("node isnt node xmlElement")
                    continue
            }
            
            // what is this layout's name
            let layoutName = xmlElement.attributeForName("name")?.stringValue ?? ""
            if layoutName.caseInsensitiveCompare(targetLayoutName) == NSComparisonResult.OrderedSame {
                // this is the target layout we want we're done here
                targetLayoutNode = n
                break
            } else if layoutName.caseInsensitiveCompare("default") == NSComparisonResult.OrderedSame {
                // this is the default layout
                defaultLayoutNode = n
            }
        }
        
        if targetLayoutNode != nil {
            // load this one
            try parseTransformationsNodes(targetLayoutNode!)
        } else if defaultLayoutNode != nil {
            // load default
            try parseTransformationsNodes(defaultLayoutNode!)
        }
    }
}