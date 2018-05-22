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
    var itemsBeingDragged: [BookmarkDirectory.Node]?
    
    override func viewDidLoad() {
        dateFormatter.dateStyle = .medium
        
        // setup dragging
        outlineView.registerForDraggedTypes([.string])
        outlineView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        
        // setup sort descriptors
        outlineView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("HostnameColumn"))!.sortDescriptorPrototype = NSSortDescriptor(key: "HostnameColumn", ascending: true)
        outlineView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("UsernameColumn"))!.sortDescriptorPrototype = NSSortDescriptor(key: "UsernameColumn", ascending: true)
        outlineView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("LastConnectedColumn"))!.sortDescriptorPrototype = NSSortDescriptor(key: "LastConnectedColumn", ascending: true)
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
    
    // return the node model for each row entry
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
                output?.imageView?.image = bookmark.image
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
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        guard let node = item as? BookmarkDirectory.Node else {
            return 0
        }
        
        // apply different row size for different item
        return node.type == .bookmarkGroup ? 80 : 40
    }
    ///// collapse and expand /////
    
    func outlineViewItemDidCollapse(_ notification: Notification) {
        guard let node = notification.userInfo?["NSObject"] as? BookmarkDirectory.Node else {
            return
        }
        
        // update model
        bookmarkDirectory.collapse(bookmarkGroupId: node.id)
        
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {
        guard let node = notification.userInfo?["NSObject"] as? BookmarkDirectory.Node else {
            return
        }
        
        // update model
        bookmarkDirectory.expand(bookmarkGroupId: node.id)
        
    }
    
    // when user click on the column header and cause it to sort
    func outlineView(_ outlineView: NSOutlineView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor =  outlineView.sortDescriptors.first else {
            return
        }
        
        if sortDescriptor.key == "HostnameColumn" {
            bookmarkDirectory.sortData(by: .hostname, ascending: sortDescriptor.ascending)
        }else if sortDescriptor.key == "UsernameColumn" {
            bookmarkDirectory.sortData(by: .username, ascending: sortDescriptor.ascending)
        }else if sortDescriptor.key == "LastConnectedColumn" {
            bookmarkDirectory.sortData(by: .lastConnected, ascending: sortDescriptor.ascending)
        }
    }
    
    
    //// dragg and drop ////
    
    // pasteboardwriter
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        guard let node = item as? BookmarkDirectory.Node else {
            return nil
        }
        
        // disable dragging for group
        if node.type == .bookmarkGroup {
            return nil
        }
        
        return NSString(string: node.id)
    }
    
    
    // drag started
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        itemsBeingDragged = draggedItems.map({ $0 as! BookmarkDirectory.Node })
        session.draggingPasteboard.setData(Data(), forType: .string)
    }
    
    // drag ended
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        itemsBeingDragged = nil
    }
    
    
    // validate
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        print("validate drop: proposedItem: \(item), proposedChildIndex: \(index)")
        
        var retval = NSDragOperation()
        
        // prevent dropping outside of group
        guard let parent = item as? BookmarkDirectory.Node else {
            return retval
        }
        
        // prevent dropping on to an item
        if index == -1 {
            return retval
        }
        
        return NSDragOperation.generic
    }

    // accept
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        let targetParent = item as! BookmarkDirectory.Node
        
        
        guard let draggedItems = itemsBeingDragged else {
            return false
        }
        
        outlineView.beginUpdates()
        var insertedItem = 0
        for draggedItem in draggedItems {
            let draggedIndex = outlineView.childIndex(forItem: draggedItem)
            let draggedParent = outlineView.parent(forItem: draggedItem) as! BookmarkDirectory.Node
            var targetIndex = index
            
            if draggedParent === targetParent {
                // moving to its own location
                if targetIndex == draggedIndex+1 {
                    continue
                }
                
                if draggedIndex < targetIndex {
                    targetIndex -= 1
                }
                
                // outline view's index indicate the space between items. so if we have items:
                // A B
                // index 0 = before A
                // index 1 = between A B
                // index 2 = after B
                // but our backing model is an array, so we have to handle this case
//                targetIndex = min(targetIndex, targetParent.children.count-1)
            }
            
//            targetIndex += insertedItem
            
//            targetIndex = max(0, min(targetIndex, targetParent.children.count-1))
            print("drop item fromParent: \(draggedParent.id), fromIndex: \(draggedIndex), toParent: \(targetParent.id), toIndex: \(targetIndex)")
            
            // update model
            let fromIndexPath = IndexPath(item: draggedIndex, section: outlineView.childIndex(forItem: draggedParent))
            var toIndexPath = IndexPath(item: targetIndex, section: outlineView.childIndex(forItem: targetParent))
            
            
            bookmarkDirectory.moveBookmark(from: fromIndexPath, to: toIndexPath)
            // update view
            outlineView.moveItem(at: draggedIndex, inParent: draggedParent, to: targetIndex, inParent: targetParent)
        
//            insertedItem += 1
        }
        outlineView.endUpdates()
        return true
    }
}

extension BookmarkListViewController: BookmarkDirectorySubscriber {
    func directoryReloaded() {
        outlineView.reloadData()
        let groupNodes = bookmarkDirectory.node(where: { $0.type == .bookmarkGroup })
        
        outlineView.beginUpdates()
        for n in groupNodes {
            let g = bookmarkDirectory.bookmarkGroup(withId: n.id)!
            if g.isCollapsed {
                outlineView.collapseItem(n, collapseChildren: false)
            } else {
                outlineView.expandItem(n, expandChildren: false)
            }
        }
        outlineView.endUpdates()
    }
}

