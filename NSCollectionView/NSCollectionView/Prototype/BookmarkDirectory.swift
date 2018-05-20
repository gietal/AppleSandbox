//
//  BookmarkDirectory.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/19/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class Bookmark {
    let id = UUID().uuidString
    var image: NSImage?
    var hostname = ""
    var username: String?
    var lastConnected: Date?
}

class RemoteResource {
    let id = UUID().uuidString
    var image: NSImage?
    var appName = ""
}

class WorkspaceSetting {
    let id = UUID().uuidString
    var title = ""
    var isCollapsed = false
}

class BookmarkGroup {
    let id = UUID().uuidString
    var title = ""
    var isCollapsed = false
}

protocol BookmarkDirectorySubscriber {
    func directoryReloaded()
}

// modelss
@objc @IBDesignable class BookmarkDirectory: NSObject {
    class Node {
        enum ContentType {
            case bookmark
            case remoteResource
            case workspace
            case bookmarkGroup
        }
        
        public init(_ bookmark: Bookmark, parent: Node? = nil) {
            self.parent = parent
            type = .bookmark
            id = bookmark.id
        }
        public init(_ group: BookmarkGroup, parent: Node? = nil) {
            self.parent = parent
            type = .bookmarkGroup
            id = group.id
        }
        
        func addChild(_ node: Node) {
            var n = node
            n.parent = self
            children.append(n)
        }
        
        // lightweight container
        public fileprivate(set) var parent: Node?
        fileprivate var children = [Node]()
        var type = ContentType.bookmark
        var id = ""
    }
    
    public var subscribers = Subscribable<BookmarkDirectorySubscriber>()
    
    fileprivate var bookmarkNodes = [Node]()
    
    // Collection view data source
    public var numberOfSections: Int {
        return bookmarkNodes.count
    }
    
    public func numberOfItemsInSection(_ section: Int) -> Int {
        return bookmarkNodes[section].children.count
    }
    
    public func bookmarkGroup(for indexPath: IndexPath) -> BookmarkGroup {
        let node = bookmarkNodes[indexPath.section]
        return groupMap[node.id]!
    }
    public func bookmark(for indexPath: IndexPath) -> Bookmark {
        let node = bookmarkNodes[indexPath.section].children[indexPath.item]
        return bookmarkMap[node.id]!
    }
    
    // data provider
    fileprivate var imageFiles = [ImageFile]()
    fileprivate var groupMap = [String: BookmarkGroup]()
    fileprivate var bookmarkMap = [String: Bookmark]()
    
    func loadImages(fromFolder folderURL: URL) {
        let urls = getFilesURLFromFolder(folderURL)
        if let urls = urls {
            print("\(urls.count) images found in directory \(folderURL.lastPathComponent)")
            
            for url in urls {
                print("\(url.lastPathComponent)")
            }
            createImageFilesForUrls(urls)
            setupBookmarkAndGroup()
            subscribers.notifyAll {
                $0.directoryReloaded()
            }
        }
        
    }
    
    fileprivate func setupBookmarkAndGroup() {
        let sections = [3,5]
        var groupIndex = 0
        var imageIndex = 0
        bookmarkNodes = []
        
        for count in sections {
            // create group
            let group = BookmarkGroup()
            group.title = "Bookmark Group \(groupIndex)"
            groupMap[group.id ] = group
            
            // create node
            var sectionNode = Node(group)
            bookmarkNodes.append(sectionNode)
            
            for i in 0..<count {
                // create bookmark
                let bookmark = Bookmark()
                let imageFile = imageFiles[imageIndex]
                bookmark.hostname = "[\(groupIndex), \(i)]"//bookmark.id
                bookmark.image = imageFile.thumbnail
                bookmarkMap[bookmark.id] = bookmark
                imageIndex = imageIndex == imageFiles.count-1 ? 0 : imageIndex + 1
                
                sectionNode.addChild(Node(bookmark))
            }
            
            groupIndex += 1
        }
    }
    
    fileprivate func getFilesURLFromFolder(_ folderURL: URL) -> [URL]? {
        
        let options: FileManager.DirectoryEnumerationOptions =
            [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        let fileManager = FileManager.default
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        
        guard let directoryEnumerator = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: resourceValueKeys,
                                                               options: options, errorHandler: { url, error in
                                                                print("`directoryEnumerator` error: \(error).")
                                                                return true
        }) else { return nil }
        
        var urls: [URL] = []
        for case let url as URL in directoryEnumerator {
            do {
                let resourceValues = try (url as NSURL).resourceValues(forKeys: resourceValueKeys)
                guard let isRegularFileResourceValue = resourceValues[URLResourceKey.isRegularFileKey] as? NSNumber else { continue }
                guard isRegularFileResourceValue.boolValue else { continue }
                guard let fileType = resourceValues[URLResourceKey.typeIdentifierKey] as? String else { continue }
                guard UTTypeConformsTo(fileType as CFString, "public.image" as CFString) else { continue }
                urls.append(url)
            }
            catch {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
    fileprivate func createImageFilesForUrls(_ urls: [URL]) {
        if imageFiles.count > 0 {   // When not initial folder
            imageFiles.removeAll()
        }
        for url in urls {
            if let imageFile = ImageFile(url: url) {
                imageFiles.append(imageFile)
            }
        }
    }
}
