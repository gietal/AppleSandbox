//
//  BookmarkListViewController.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/20/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Cocoa

class BookmarkListViewController: NSViewController {

    struct ColumnHeaderOptions: OptionSet {
        let rawValue: UInt
        
        static let username = ColumnHeaderOptions(rawValue: 1 << 0)
        static let gateway = ColumnHeaderOptions(rawValue: 1 << 1)
        static let lastConnected = ColumnHeaderOptions(rawValue: 1 << 2)
        
        static let standardOptions: ColumnHeaderOptions = [.username]
    }
    
    enum columnHeaderIdentifier: String {
        case hostname = "HostnameColumn"
        case username = "UsernameColumn"
        case gateway = "GatewayColumn"
        case lastConnected = "LastConnectedColumn"
    }
    
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
    var columnHeaderOptions = ColumnHeaderOptions.standardOptions
    var columnMap = [columnHeaderIdentifier: NSTableColumn]()
    
    @IBOutlet weak var columnHeaderMenu: NSMenu!
    override func viewDidLoad() {
        dateFormatter.dateStyle = .medium
        
        // setup dragging
        outlineView.registerForDraggedTypes([.string])
        outlineView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        
        // setup sort descriptors
        outlineView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("HostnameColumn"))!.sortDescriptorPrototype = NSSortDescriptor(key: "HostnameColumn", ascending: true)
        outlineView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("UsernameColumn"))!.sortDescriptorPrototype = NSSortDescriptor(key: "UsernameColumn", ascending: true)
        outlineView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("LastConnectedColumn"))!.sortDescriptorPrototype = NSSortDescriptor(key: "LastConnectedColumn", ascending: true)
    
        // sync column header options to the menu
        columnHeaderMenu.item(withTitle: "Username")?.state = columnHeaderOptions.contains(.username) ? .on : .off
        columnHeaderMenu.item(withTitle: "Gateway")?.state = columnHeaderOptions.contains(.gateway) ? .on : .off
        columnHeaderMenu.item(withTitle: "Last Connected")?.state = columnHeaderOptions.contains(.lastConnected) ? .on : .off
        
        
        // grab the columns
        for column in outlineView.tableColumns {
            if column.identifier == NSUserInterfaceItemIdentifier(rawValue: "UsernameColumn") {
                columnMap[.username] = column
            } else if column.identifier == NSUserInterfaceItemIdentifier(rawValue: "GatewayColumn") {
                columnMap[.gateway] = column
            } else if column.identifier == NSUserInterfaceItemIdentifier(rawValue: "LastConnectedColumn") {
                columnMap[.lastConnected] = column
            }
        }
        
        // sync the options to the columns
        if !columnHeaderOptions.contains(.username) {
            outlineView.removeTableColumn(columnMap[.username]!)
        }
        if !columnHeaderOptions.contains(.gateway) {
            outlineView.removeTableColumn(columnMap[.gateway]!)
        }
        if !columnHeaderOptions.contains(.lastConnected) {
            outlineView.removeTableColumn(columnMap[.lastConnected]!)
        }
    }
    
    @IBAction func menuPressed1(_ sender: Any) {
    }
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
    }
    
    @IBAction func columnHeaderMenuUsernamePressed(_ sender: NSMenuItem) {
        if columnHeaderOptions.contains(.username) {
            columnHeaderOptions.remove(.username)
        } else {
            columnHeaderOptions.insert(.username)
        }
        sender.state = columnHeaderOptions.contains(.username) ? .on : .off
        if sender.state == .on {
            outlineView.addTableColumn(columnMap[.username]!)
        } else {
            outlineView.removeTableColumn(columnMap[.username]!)
        }
    }
    @IBAction func columnHeaderMenuGatewayPressed(_ sender: NSMenuItem) {
        if columnHeaderOptions.contains(.gateway) {
            columnHeaderOptions.remove(.gateway)
        } else {
            columnHeaderOptions.insert(.gateway)
        }
        sender.state = columnHeaderOptions.contains(.gateway) ? .on : .off
        if sender.state == .on {
            outlineView.addTableColumn(columnMap[.gateway]!)
        } else {
            outlineView.removeTableColumn(columnMap[.gateway]!)
        }
    }
    @IBAction func columnHeaderMenuLastConnectedPressed(_ sender: NSMenuItem) {
        if columnHeaderOptions.contains(.lastConnected) {
            columnHeaderOptions.remove(.lastConnected)
        } else {
            columnHeaderOptions.insert(.lastConnected)
        }
        sender.state = columnHeaderOptions.contains(.lastConnected) ? .on : .off
        if sender.state == .on {
            outlineView.addTableColumn(columnMap[.lastConnected]!)
        } else {
            outlineView.removeTableColumn(columnMap[.lastConnected]!)
        }
    }
}

extension BookmarkListViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return false
        if let node = item as? BookmarkDirectory.Node {
            return node.type == .bookmarkGroup
        }
        return false
    }
    // determine how many children does a node have
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let node = item as? BookmarkDirectory.Node {
            if node.type == .bookmarkGroup {
                let group = bookmarkDirectory.bookmarkGroup(withId: node.id)!
                if group.isCollapsed {
//                    return 0
                }
            }
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
            return node.type == .bookmarkGroup || node.type == .workspaceGroup
        }
        return false
    }
    
}
extension BookmarkListViewController: NSOutlineViewDelegate {
    // disable moving the first column
    func outlineView(_ outlineView: NSOutlineView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
        if columnIndex == 0 || newColumnIndex == 0 {
            return false
        }
        return true
    }
    
    
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
        } else if column.identifier == NSUserInterfaceItemIdentifier("GatewayColumn") {
            switch node.type {
            case .bookmark:
                let bookmark = bookmarkDirectory.bookmark(withId: node.id)!
                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("GatewayCell"), owner: self) as? NSTableCellView
                output?.textField?.stringValue = bookmark.gateway ?? ""
//            case .bookmarkGroup:
//                output = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("FolderCell"), owner: self) as? NSTableCellView
//                output?.textField?.stringValue = ""
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
        return node.type == .bookmarkGroup ? 50 : 40
    }
    ///// collapse and expand /////
    
    func outlineViewItemDidCollapse(_ notification: Notification) {
        guard let node = notification.userInfo?["NSObject"] as? BookmarkDirectory.Node else {
            return
        }
        
        // update model
        bookmarkDirectory.collapse(bookmarkGroupId: node.id, notify: false)
        
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {
        guard let node = notification.userInfo?["NSObject"] as? BookmarkDirectory.Node else {
            return
        }
        
        // update model
        bookmarkDirectory.expand(bookmarkGroupId: node.id, notify: false)
        
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
//        print("validate drop: proposedItem: \(String(describing: item)), proposedChildIndex: \(index)")
        
        let retval = NSDragOperation()
        
        // prevent dropping outside of group
        if item == nil {
            return retval
        }
        
        // prevent dropping on to an item
        if index == NSOutlineViewDropOnItemIndex {
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
        
        print("====== begin dropping items ======")
        outlineView.beginUpdates()
        
        // this modifier was found after hours of figuring out how collectionview works the hard way
        var indexModifier = 0

        for draggedItem in draggedItems {
            let draggedIndex = outlineView.childIndex(forItem: draggedItem)
            let draggedParent = outlineView.parent(forItem: draggedItem) as! BookmarkDirectory.Node
            var targetIndex = index
            
            // new items will be repositioned according to this modifier
            targetIndex += indexModifier
            
            if draggedParent === targetParent {
                // if moving item from the same parent
                if draggedIndex < index {
                    // and our target is in front of us, reduce index by 1
                    // since we will remove, then readd this item to the same array
                    targetIndex = max(0, index - 1)
                } else {
                    // otherwise it's ok to put the enxt item after this item
                    indexModifier += 1
                }

            } else {
                // moving to a new parent, it's ok to put the next item after this item
                indexModifier += 1
            }
            
            print("drop item fromParent: \(draggedParent.id), fromIndex: \(draggedIndex), toParent: \(targetParent.id), toIndex: \(targetIndex)")
            
            // update model
            let fromIndexPath = IndexPath(item: draggedIndex, section: outlineView.childIndex(forItem: draggedParent))
            let toIndexPath = IndexPath(item: targetIndex, section: outlineView.childIndex(forItem: targetParent))
            bookmarkDirectory.moveBookmark(from: fromIndexPath, to: toIndexPath)
            
            // update view
            outlineView.moveItem(at: draggedIndex, inParent: draggedParent, to: targetIndex, inParent: targetParent)

        }
        
        outlineView.endUpdates()
        return true
    }
    
    
}

extension BookmarkListViewController: BookmarkDirectorySubscriber {
    func onSectionCollapseStateChanged(at index: IndexPath, sectionNode: BookmarkDirectory.Node, collapsed: Bool) {
        // do nothing, already handled
    }
    
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

extension BookmarkListViewController {
    // actions
    
}
