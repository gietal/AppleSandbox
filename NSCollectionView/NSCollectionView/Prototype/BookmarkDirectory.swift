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
    
    enum SortBy {
        case none
        case hostname
        case username
        case lastConnected
    }
    
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
            node.parent = self
            children.append(node)
        }
        
        func insertChild(_ node: Node, at: Int) {
            node.parent = self
            children.insert(node, at: at)
        }
        
        func removeChildren(where shouldRemove: (Node) -> Bool) {
            
            var i = 0
            while i < children.count {
                if shouldRemove(children[i]) {
                    // remove this one
                    children.remove(at: i)
                } else {
                    // onto the next one
                    i += 1
                }
            }
        }
        
        // lightweight container
        public fileprivate(set) var parent: Node?
        public fileprivate(set) var children = [Node]()
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
    
    // Outline View data source
    
    public func collapse(bookmarkGroupId: String) {
        bookmarkGroup(withId: bookmarkGroupId)?.isCollapsed = true
    }
    public func expand(bookmarkGroupId: String) {
        bookmarkGroup(withId: bookmarkGroupId)?.isCollapsed = false
    }
    
    public func node(at indexPath: IndexPath) -> Node {
        var theIndexPath = indexPath
        // assume at least 1
        let firstIndex = theIndexPath.popFirst()!
        var currentNode = bookmarkNodes[firstIndex]
        
        // then recurse
        while let childIndex = theIndexPath.popFirst() {
            currentNode = currentNode.children[childIndex]
        }
        
        return currentNode
        
    }
    
    public func node(where include: (Node) -> Bool) -> [Node] {
        var output = [Node]()
        for root in bookmarkNodes {
            output.append(contentsOf: node(root: root, where: include))
        }
        return output
    }
    
    fileprivate func node(root: Node, where include: (Node) -> Bool) -> [Node] {
        var output = [Node]()
        
        // search self
        if include(root) {
            output.append(root)
        }
        
        // search children
        for c in root.children {
            output.append(contentsOf: node(root: c, where: include))
        }
        return output
    }
    
    // data provider
    fileprivate var imageFiles = [ImageFile]()
    fileprivate var groupMap = [String: BookmarkGroup]()
    fileprivate var bookmarkMap = [String: Bookmark]()
    
    public func bookmark(withId id:String) -> Bookmark? {
        return bookmarkMap[id]
    }
    
    public func bookmarkGroup(withId id: String) -> BookmarkGroup? {
        return groupMap[id]
    }
    
    // public methods
    
    func sortData(by whatToSort: SortBy, ascending: Bool) {
        if whatToSort == .none {
            return
        }
        
        // sort root
        bookmarkNodes.sort { (a, b) -> Bool in
            // todo: handle different types, folder vs workspace folder
            let ga = bookmarkGroup(withId: a.id)!
            let gb = bookmarkGroup(withId: b.id)!
            return sort(groupA: ga, groupB: gb, by: whatToSort, ascending: ascending)
        }
        
        // sort children
        for node in bookmarkNodes {
            node.children.sort { (a, b) -> Bool in
                // todo: handle different types, subfolder vs desktop vs remoteresource
                // container vs connectable?
                let ba = bookmark(withId: a.id)!
                let bb =  bookmark(withId: b.id)!
                return sort(bookmarkA: ba, bookmarkB: bb, by: whatToSort, ascending: ascending)
            }
        }
        
        subscribers.notifyAll {
            $0.directoryReloaded()
        }
    }
    
    fileprivate func sort(groupA: BookmarkGroup, groupB: BookmarkGroup, by whatToSort: SortBy, ascending: Bool) -> Bool {
        switch whatToSort {
        case .hostname:
            return ascending ? groupA.title < groupB.title : groupA.title > groupB.title
        default:
            return groupA.title < groupB.title
        }
    }
    fileprivate func sort(bookmarkA: Bookmark, bookmarkB: Bookmark, by whatToSort: SortBy, ascending: Bool) -> Bool {
        switch whatToSort {
        case .hostname:
            return ascending ? bookmarkA.hostname < bookmarkB.hostname : bookmarkA.hostname > bookmarkB.hostname
        case .username:
            return ascending ? bookmarkA.username ?? "" < bookmarkB.username ?? "" : bookmarkA.username ?? "" > bookmarkB.username ?? ""
        case .lastConnected:
            if bookmarkA.lastConnected == nil {
                return ascending
            }
            if bookmarkB.lastConnected == nil {
                return !ascending
            }
            return ascending ? bookmarkA.lastConnected!.compare(bookmarkB.lastConnected!) == .orderedAscending : bookmarkA.lastConnected!.compare(bookmarkB.lastConnected!) == .orderedDescending
        default:
            break
        }
        return true
    }
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
    
    func reset() {
        setupBookmarkAndGroup()
        subscribers.notifyAll {
            $0.directoryReloaded()
        }
    }
    
    func moveBookmark(from: IndexPath, to: IndexPath) {
        let node = bookmarkNodes[from.section].children.remove(at: from.item)
        bookmarkNodes[to.section].insertChild(node, at: to.item)
    }
    
    func moveBookmarks(from fromIndexes: Set<IndexPath>, to toIndex: IndexPath) {
        // remove the bookmarks from model
        
        
        
        // consolidate items to move
        var indexMap = [Int: Set<Int>]()
        for index in fromIndexes {
            if !indexMap.contains(key: index.section) {
                indexMap[index.section] = Set<Int>()
            }
            
            indexMap[index.section]?.insert(index.item)
        }
        
        // remove items at once per each section
        var toMove = [Node]()
        for (sectionIndex, set) in indexMap {
            toMove.append(contentsOf: bookmarkNodes[sectionIndex].children.remove(at: set))
        }
        
        // reinsert on correct spot
        var targetIndex = toIndex
        for node in toMove {
            let sectionNode = bookmarkNodes[toIndex.section]
            
//            targetIndex.item = max(targetIndex.item, sectionNode.children.count)
            sectionNode.insertChild(node, at: targetIndex.item)
            targetIndex.item += 1
        }
        
        // tell the subscribers item is moved?
    }
    
    fileprivate func setupBookmarkAndGroup() {
        let sections = [5, 5, 5]
        let usernames = ["rdpuser", nil, "tslabadmin"]
        var groupIndex = 0
        var imageIndex = 0
        bookmarkNodes = []
        
        var date = Date()
        
        for count in sections {
            // create group
            let group = BookmarkGroup()
            group.title = "Bookmark Group \(groupIndex)"
            groupMap[group.id ] = group
            
            // create node
            let sectionNode = Node(group)
            bookmarkNodes.append(sectionNode)
            
            for i in 0..<count {
                // create bookmark
                let bookmark = Bookmark()
                let imageFile = imageFiles[imageIndex]
                bookmark.hostname = "[\(groupIndex), \(i)]"//bookmark.id
                bookmark.image = imageFile.thumbnail
                bookmark.username = usernames[Int(arc4random_uniform(UInt32(usernames.count)))]
                date = date.addingTimeInterval(-60 * 60 * 48)
                bookmark.lastConnected = arc4random_uniform(2) == 0 ? nil : date
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
