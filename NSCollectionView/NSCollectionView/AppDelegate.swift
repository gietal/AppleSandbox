//
//  AppDelegate.swift
//  NSCollectionView
//
//  Created by gietal-dev on 5/14/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var bookmarkDirectory = BookmarkDirectory()
    
    @IBOutlet weak var bookmarkThumbnailViewController: BookmarkThumbnailViewController!
    @IBOutlet weak var bookmarkListViewController: BookmarkListViewController!
    
    @IBAction func resetDirectory(_ sender: Any) {
        bookmarkDirectory.reset()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // init subscribers
        bookmarkThumbnailViewController.bookmarkDirectory = bookmarkDirectory
        bookmarkListViewController.bookmarkDirectory = bookmarkDirectory
        
        // init bookmark directory
        bookmarkDirectory.loadImages(fromFolder: URL(string: "\(NSHomeDirectory())/Pictures/test")!)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

