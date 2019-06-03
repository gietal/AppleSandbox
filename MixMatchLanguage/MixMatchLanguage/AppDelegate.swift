//
//  AppDelegate.swift
//  MixMatchLanguage
//
//  Created by gietal-dev on 5/10/19.
//  Copyright © 2019 gietal-dev. All rights reserved.
//

import Cocoa
import SwiftFramework
import CoreSpotlight

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let swiftClass = SwiftClass()

    public func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        return true
    }
    
    func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        swiftClass.doStuff()
        
        let url = getAppGroupApplicationSupportDirectory()
        print("group app support dir: \(url.absoluteString)")
        
        // test creating file
        let result = FileManager.default.createFile(atPath: url.appendingPathComponent("hello.txt").path, contents: "hello".data(using: .utf8), attributes: nil)
        // ~/Library/Containers/com.gietal.sandbox.MixMatchLanguage/Data/Library/Application%20Support/com.gietal.sandbox.MixMatchLanguage/
        
        // add 1 item to the searchable index
        let searchableAttribute = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchableAttribute.title = "item from mixmatch"
        searchableAttribute.contentDescription = "description of item"
        let searchableItem = CSSearchableItem(uniqueIdentifier: "123", domainIdentifier: "mixmatch", attributeSet: searchableAttribute)
        searchableItem.expirationDate = Date.distantFuture // by default spotlight item expire after 1 year, we make this to be infinte lifetime
    
        CSSearchableIndex.default().indexSearchableItems([searchableItem], completionHandler: { error in
            if let error = error {
                print("error addig index: \(error)")
            }
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

