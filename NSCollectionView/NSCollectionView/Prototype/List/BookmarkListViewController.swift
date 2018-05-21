//
//  BookmarkListViewController.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/20/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

class BookmarkListViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    weak var bookmarkDirectory: BookmarkDirectory! {
        didSet {
            // subscribe
            bookmarkDirectory.subscribers.subscribe(self)
            outlineView.dataSource = self
            outlineView.delegate = self
        }
    }
    let dateFormatter  = DateFormatter()
    
    override func viewDidLoad() {
        dateFormatter.dateStyle = .medium
    }
    
}

extension BookmarkListViewController: NSOutlineViewDataSource {
    
    // determine how many children does a node have
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let node = item as? BookmarkDirectory.Node {
            return node.children.count
        }
        
        // top-level item
        return bookmarkDirectory.numberOfSections
    }
    
    // return the node
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let node = item as? BookmarkDirectory.Node {
            return node.children[index]
        }
        
        // top-level item
        return bookmarkDirectory.node(at: IndexPath(indexes: [index]))
    }
    
    // allow node to be expandable
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let node = item as? BookmarkDirectory.Node {
            return node.type == .bookmarkGroup || node.type == .workspace
        }
        return false
    }
}
extension BookmarkListViewController: NSOutlineViewDelegate {
    // determine the content of each cell column for each item
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let node = item as? BookmarkDirectory.Node,
            let column = tableColumn else {
            return nil
        }
        
        var output: NSTableCellView?
        
        if column.identifier == NSUserInterfaceItemIdentifier("HostnameColumn") {
            switch node.type {
            case .bookmark:
                let bookmark = bookmarkDirectory.bookmark(withId: node.id)!
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("HostnameCell"), owner: self) as? NSTableCellView
                output?.textField?.stringValue = bookmark.hostname
            case .bookmarkGroup:
                let group = bookmarkDirectory.bookmarkGroup(withId: node.id)!
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("FolderCell"), owner: self) as? NSTableCellView
                output?.textField?.stringValue = group.title
            default:
                break
            }
        } else if column.identifier == NSUserInterfaceItemIdentifier("UsernameColumn") {
            switch node.type {
            case .bookmark:
                let bookmark = bookmarkDirectory.bookmark(withId: node.id)!
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("UsernameCell"), owner: self) as? NSTableCellView
                output?.textField?.stringValue = bookmark.username ?? ""
            case .bookmarkGroup:
                let group = bookmarkDirectory.bookmarkGroup(withId: node.id)!
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("FolderCell"), owner: self) as? NSTableCellView
                output?.textField?.stringValue = ""
            default:
                break
            }
        } else if column.identifier == NSUserInterfaceItemIdentifier("LastConnectedColumn") {
            switch node.type {
            case .bookmark:
                let bookmark = bookmarkDirectory.bookmark(withId: node.id)!
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("UsernameCell"), owner: self) as? NSTableCellView
                if let date = bookmark.lastConnected {
                    output?.textField?.stringValue = dateFormatter.string(from: date)
                } else {
                    output?.textField?.stringValue = ""
                }
                
            case .bookmarkGroup:
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("FolderCell"), owner: self) as? NSTableCellView
                output?.textField?.stringValue = ""
            default:
                break
            }
        }
        
        
        return output
    }
}

extension BookmarkListViewController: BookmarkDirectorySubscriber {
    func directoryReloaded() {
        outlineView.reloadData()
    }
}

