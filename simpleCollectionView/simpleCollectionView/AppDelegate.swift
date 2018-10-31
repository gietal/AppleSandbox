//
//  AppDelegate.swift
//  simpleCollectionView
//
//  Created by gietal-dev on 11/10/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var collectionView: NSCollectionView!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let flow = collectionView.collectionViewLayout as! NSCollectionViewFlowLayout
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

