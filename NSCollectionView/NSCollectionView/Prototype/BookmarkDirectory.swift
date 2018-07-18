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
    var username: String?
    var lastConnected: Date?
}

class WorkspaceGroup {
    let id = UUID().uuidString
    var title: String {
        set {
            myTitle = newValue
        }
        get {
            return workspaceSetting?.title ?? myTitle
        }
    }
    var workspaceSetting: WorkspaceSetting? // only valid for root feed, subfolder wont have this
    
    private var myTitle = ""
}

class BookmarkGroup {
    let id = UUID().uuidString
    var title = ""
    var isCollapsed = false
    var isCollapsable = true
}

protocol BookmarkDirectorySubscriber {
    func directoryReloaded()
    func onSectionCollapseStateChanged(at index: IndexPath, sectionNode: BookmarkDirectory.Node, collapsed: Bool)
    
}

// modelss
@objc @IBDesignable class BookmarkDirectory: NSObject {
    
    enum SortBy {
        case none
        case hostname
        case username
        case lastConnected
    }
    
    struct Filter {
        enum Mode {
            case desktop
            case feeds
        }
        
        var searchString: String = ""
        var excludeEmptySection: Bool = false
        var mode: Mode = .desktop
    }
    
    class Node {
        enum ContentType {
            case bookmark
            case remoteResource
            case workspaceGroup
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
        public init(_ workspaceGroup: WorkspaceGroup, parent: Node? = nil) {
            self.parent = parent
            type = .workspaceGroup
            id = workspaceGroup.id
        }
        public init(_ copy: Node, parent: Node?) {
            self.parent = parent
            self.type = copy.type
            self.id = copy.id
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
    
    public var filter: Filter? {
        didSet {
            // apply filter
            applyFilter()
            
            subscribers.notifyAll {
                $0.directoryReloaded()
            }
            
        }
    }
    public var subscribers = Subscribable<BookmarkDirectorySubscriber>()
    
    fileprivate var originalBookmarkNodes = [Node]()
    fileprivate var filteredBookmarkNodes = [Node]()
    fileprivate var workspaceNodes = [Node]()
    
    // Collection view data source
    public var numberOfSections: Int {
        return filteredBookmarkNodes.count
    }
    
    public func numberOfItemsInSection(_ section: Int) -> Int {
        return filteredBookmarkNodes[section].children.count
    }
    
    public func bookmarkGroup(for indexPath: IndexPath) -> BookmarkGroup {
        let node = filteredBookmarkNodes[indexPath.first!]
        return groupMap[node.id]!
    }
    public func bookmark(for indexPath: IndexPath) -> Bookmark {
        let node = filteredBookmarkNodes[indexPath.section].children[indexPath.item]
        return bookmarkMap[node.id]!
    }
    
    // Outline View data source
    
    public func node(at indexPath: IndexPath) -> Node {
        var theIndexPath = indexPath
        // assume at least 1
        let firstIndex = theIndexPath.popFirst()!
        var currentNode = filteredBookmarkNodes[firstIndex]
        
        // then recurse
        while let childIndex = theIndexPath.popFirst() {
            currentNode = currentNode.children[childIndex]
        }
        
        return currentNode
        
    }
    
    public func node(where include: (Node) -> Bool) -> [Node] {
        var output = [Node]()
        for root in filteredBookmarkNodes {
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
    fileprivate var workspaceMap = [String: WorkspaceSetting]()
    fileprivate var remoteResourceMap = [String: RemoteResource]()
    fileprivate var workspaceGroupMap = [String: WorkspaceGroup]() // nonpersistent
    
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
        filteredBookmarkNodes.sort { (a, b) -> Bool in
            // todo: handle different types, folder vs workspace folder
            let ga = bookmarkGroup(withId: a.id)!
            let gb = bookmarkGroup(withId: b.id)!
            return sort(groupA: ga, groupB: gb, by: whatToSort, ascending: ascending)
        }
        
        // sort children
        for node in filteredBookmarkNodes {
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
            reset()
        }
        
    }
    
    func reset() {
        setupBookmarkAndGroup()
        applyFilter()
        subscribers.notifyAll {
            $0.directoryReloaded()
        }
    }
    
    public func collapse(bookmarkGroupId: String, notify: Bool = true) {
        if let index = filteredBookmarkNodes.index(where: { $0.id == bookmarkGroupId }) {
            collapseSection(at: IndexPath(arrayLiteral: index), notify: notify)
        }
        
    }
    
    public func expand(bookmarkGroupId: String, notify: Bool = true) {
        if let index = filteredBookmarkNodes.index(where: { $0.id == bookmarkGroupId }) {
            expandSection(at: IndexPath(arrayLiteral: index), notify: notify)
        }
        
    }
    
    func collapseSection(at: IndexPath, notify: Bool = true) {
        collapseSection(collapse: true, at: at, notify: notify)
    }
    
    func expandSection(at: IndexPath, notify: Bool = true) {
        collapseSection(collapse: false, at: at, notify: notify)
    }
    
    fileprivate func collapseSection(collapse: Bool, at: IndexPath, notify: Bool) {
        var node: Node?
        var firstItem = true
        for index in at {
            if firstItem {
                node = filteredBookmarkNodes[index]
                firstItem = false
            } else {
                node = node!.children[index]
            }
        }
        
        guard let sectionNode = node else {
            return
        }
        
        if sectionNode.type != .bookmarkGroup {
            return
        }
        
        let group = bookmarkGroup(withId: sectionNode.id)!
        group.isCollapsed = collapse
        if notify {
            subscribers.notifyAll {
                $0.onSectionCollapseStateChanged(at: at, sectionNode: sectionNode, collapsed: collapse)
            }
        }
        
    }
    
    func moveBookmark(from: IndexPath, to: IndexPath) {
        let node = filteredBookmarkNodes[from.section].children.remove(at: from.item)
        filteredBookmarkNodes[to.section].insertChild(node, at: to.item)
    }
    
    func moveBookmarks(from fromIndexes: Set<IndexPath>, to toIndex: IndexPath) {
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
            toMove.append(contentsOf: filteredBookmarkNodes[sectionIndex].children.remove(at: set))
        }
        
        // reinsert on correct spot
        var targetIndex = toIndex
        for node in toMove {
            let sectionNode = filteredBookmarkNodes[toIndex.section]
            
//            targetIndex.item = max(targetIndex.item, sectionNode.children.count)
            sectionNode.insertChild(node, at: targetIndex.item)
            targetIndex.item += 1
        }
        
        // tell the subscribers item is moved?
    }
    
    fileprivate func applyFilter() {
        filteredBookmarkNodes = []
        filteredBookmarkNodes = originalBookmarkNodes
        
        guard let filter = filter else {
            return
        }
//        if filter.mode == .desktop {
//
//            for sectionNode in originalBookmarkNodes {
//
//                // skip empty
//                if filter.excludeEmptySection && sectionNode.children.count == 0 {
//                    continue
//                }
//
//                if let group = bookmarkGroup(withId: sectionNode.id) {
//                    let includeTitle = group.title.contains(filter.searchString)
//                }
//            }
//
//        } else {
//
//        }
    }
    
    fileprivate func setupBookmarkAndGroup() {
        let sections = [10, 10, 10]
        let usernames = ["rdpuser", nil, "tslabadmin"]
        var groupIndex = 0
        var imageIndex = 0
        originalBookmarkNodes = []
        groupMap = [:]
        bookmarkMap = [:]
        
        var date = Date()
        
        for count in sections {
            // create group
            let group = BookmarkGroup()
            group.title = "Bookmark Group \(groupIndex)"
            groupMap[group.id ] = group
            
            // create node
            let sectionNode = Node(group)
            originalBookmarkNodes.append(sectionNode)
            
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
    
    /*
    fileprivate func setupWorkspaces() {
        let sections: [(Int, [Int])] = [(3, []), (3,[3, 3]) ]
        let usernames = ["rdpuser", nil, "tslabadmin"]
        var workspaceIndex = 0
        var imageIndex = 0
        workspaceNodes = []
        
        var date = Date()
        
        for (rootCount, subfolders) in sections {
            // create workspace
            let workspace = WorkspaceSetting()
            workspace.title = "Workspace Feed \(workspaceIndex)"
            workspace.username = usernames[Int(arc4random_uniform(UInt32(usernames.count)))]
            workspaceMap[workspace.id ] = workspace
            
            // create workspace group
            let rootGroup = WorkspaceGroup()
            rootGroup.workspaceSetting = workspace
            
            // create node
            let sectionNode = Node(rootGroup)
            workspaceNodes.append(sectionNode)
            
            // create resource
            for i in 0..<rootCount {
                // create resource
                
                let resource = RemoteResource()
                let imageFile = imageFiles[imageIndex]
                resource.appName = "RemoteResource [\(workspaceIndex), \(i)]"
                resource.image = imageFile.thumbnail
                
                date = date.addingTimeInterval(-60 * 60 * 48)
                bookmark.lastConnected = arc4random_uniform(2) == 0 ? nil : date
                bookmarkMap[bookmark.id] = bookmark
                imageIndex = imageIndex == imageFiles.count-1 ? 0 : imageIndex + 1
                
                sectionNode.addChild(Node(bookmark))
            }
            
            for subfolderCount in subfolders {
                // create  workspace group
                let subfolderGroup = WorkspaceGroup()
                for  i in 0..<subfolderCount {
                    // create resource
                }
            }

            
            groupIndex += 1
        }
    }
 */
    
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
