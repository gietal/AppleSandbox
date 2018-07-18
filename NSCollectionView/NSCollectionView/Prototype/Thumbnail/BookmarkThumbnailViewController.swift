//
//  ThumbnailViewController.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/19/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

class RDCFlowLayout: NSCollectionViewFlowLayout {
    
    override func invalidateLayout() {
        super.invalidateLayout()
    }
    
    var loopCount = 0
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var original = super.layoutAttributesForElements(in: rect)
        var output = [NSCollectionViewLayoutAttributes]()
        
        if original.count == 0 {
            return original
        }
        
        // left align
        var startX = sectionInset.left
        var startY = CGFloat.leastNormalMagnitude // CGFLOAT_MIN
        
        for attribute in original  {
            if attribute.representedElementCategory != .item {
                output.append(attribute)
                continue
            }
            
            let originalPos = attribute.frame.origin
            if startY != originalPos.y {
                // we started on a new column, reset x position
                startY = originalPos.y
                startX = sectionInset.left
            }
            
            attribute.frame.origin = CGPoint(x: startX, y: startY)
            startX += attribute.frame.width + minimumInteritemSpacing
            
            output.append(attribute)
        }
        
        return output
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }
}

class BookmarkThumbnailViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!
    weak var bookmarkDirectory: BookmarkDirectory! {
        didSet {
            // subscribe
            bookmarkDirectory.subscribers.subscribe(self)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    fileprivate var indexPathsOfItemsBeingDragged: Set<IndexPath>?
    
    override func viewDidLoad() {
        setupLayout()
        setupDragAndDrop()
    }
    let flowLayout = RDCFlowLayout()
    let thumbnailLayout = ThumbnailCollectionViewLayout()
    fileprivate func setupLayout() {
        // setup the layout
        
//        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
        thumbnailLayout.itemSize = CGSize(width: 160, height: 140)
        thumbnailLayout.delegate = self
        thumbnailLayout.sectionInset = flowLayout.sectionInset
        thumbnailLayout.itemSpacing = CGSize(width: 20, height: 20)
        collectionView.collectionViewLayout = thumbnailLayout// flowLayout
        // 2
        view.wantsLayer = true
        collectionView.wantsLayer = true
        // 3
        collectionView.layer?.backgroundColor = NSColor.clear.cgColor
        collectionView.needsDisplay = true
        
        // register xibs
//        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: "BookmarkThumbnailViewItem"), bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue:"BookmarkThumbnailViewItem"))
//        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: "BookmarkThumbnailHeaderView"), bundle: nil), forSupplementaryViewOfKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue:"BookmarkThumbnailHeaderView"))
        
    }
    
    fileprivate func setupDragAndDrop(){
        // listen for string drag/drop
        collectionView.registerForDraggedTypes([.string])
        
        // listen for every string drag/drop that happen locally
        collectionView.setDraggingSourceOperationMask(.every, forLocal: true)
    }
    
    fileprivate func setupDirectory() {
        // subscrive to directory
    }
}

extension BookmarkThumbnailViewController: BookmarkDirectorySubscriber {
    func onSectionCollapseStateChanged(at index: IndexPath, sectionNode: BookmarkDirectory.Node, collapsed: Bool) {
        // reload section
        collectionView.reloadSections([index.first!])
    }
    
    func directoryReloaded() {
        // reload all
        collectionView.reloadData()
    }
}

extension BookmarkThumbnailViewController: BookmarkThumbnailHeaderViewDelegate {
    func onCollapseButtonPressed(forGroup group: BookmarkGroup) {
        if group.isCollapsed {
            bookmarkDirectory.expand(bookmarkGroupId: group.id, notify: true)
        } else {
            bookmarkDirectory.collapse(bookmarkGroupId: group.id, notify: true)
        }
        
    }
}

extension BookmarkThumbnailViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return bookmarkDirectory.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = numberOfItemsWithDummy(inSection: section)
        print("number of item in section \(section): \(count)")
        return count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        let group = bookmarkDirectory.bookmarkGroup(for: IndexPath(index: section))
        if group.isCollapsed {
            return 0
        }
        return bookmarkDirectory.numberOfItemsInSection(section)
    }
    
    func numberOfItemsWithDummy(inSection section: Int) -> Int {
        let group = bookmarkDirectory.bookmarkGroup(for: IndexPath(index: section))
        if group.isCollapsed {
            return 0
        }
        return max(bookmarkDirectory.numberOfItemsInSection(section), 1)
    }
    
    // used to create collection view item
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        var output: NSCollectionViewItem
//        print("item for [\(indexPath.section), \(indexPath.item)]")
        if numberOfItems(inSection: indexPath.section) == 0 {
            // dummy
            output = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkThumbnailViewItem"), for: indexPath)
            
        } else {
            // create the view item
            let viewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkThumbnailViewItem"), for: indexPath) as! BookmarkThumbnailViewItem
            
            // put our model in
            let bookmark = bookmarkDirectory.bookmark(for: indexPath)
            viewItem.bookmark = bookmark
            output = viewItem
        }
        
        return output
    }
    
    // used to create header/footer/interimgap section
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        var view: NSView
        if kind == .sectionHeader {
            // create header and  put our model in
            let headerView = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkThumbnailHeaderView"), for: indexPath) as! BookmarkThumbnailHeaderView
            headerView.group = bookmarkDirectory.bookmarkGroup(for: indexPath)
            headerView.delegate = self
            view = headerView
        } else {
            // non header, make nil view
            view = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: ""), for: indexPath)
            
        }
        
        return view
    }
}

extension BookmarkThumbnailViewController: ThumbnailCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, headerHeightForSection section: Int) -> CGFloat {
        return 40
    }
}

extension BookmarkThumbnailViewController: NSCollectionViewDelegateFlowLayout {
    // determine the size of the header
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        if section == 1 {
            return NSSize(width: 50, height: 100)
        }
        return NSSize(width: 100, height: 40)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        if numberOfItems(inSection: indexPath.section) == 0 {
            // dummy
            return NSSize(width: 0.0, height: 140.0)
        } else {
            return NSSize(width: 160.0, height: 140.0)
        }
    }
    
}

extension BookmarkThumbnailViewController: NSCollectionViewDelegate {
    
    //////// this part, allows the collectionview to act as Drag Source, so items can bepicked up from ////////
    
    // allow dragging item
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
        return true
    }
    
    // this is for multi section
    // thiswill be called per item dragged. we need to return pasteboard writer that represents our underlying object model
    // in this  case  just an NSURL. for bookmark can be id as NSString i guess?
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        return NSString(string: "blah")
    }
    
    /////////////////////////////////////////////////
    
    // lets us know that this collection view started dragging the items with the specified indexpaths
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        indexPathsOfItemsBeingDragged = indexPaths
    }

    // lets us decide what operation to do when the drag turns into a drop
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo,
                        proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>,
                        dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        
        print("validate drop, \(proposedDropOperation.pointee) \(proposedDropIndexPath.pointee)")
        
        // this makes sure that when user try to drop items on to another item, we make it so that it drops before the item
        if proposedDropOperation.pointee == NSCollectionView.DropOperation.on {
            proposedDropOperation.pointee = NSCollectionView.DropOperation.before
        }
        
        // this makes sure that when dropping to an empty section with a dummy, the drop position is set to 0. otherwise it may be set to 1 (after the dummy)
        if proposedDropOperation.pointee == .before && numberOfItems(inSection: proposedDropIndexPath.pointee.section) == 0 {
            proposedDropIndexPath.pointee = NSIndexPath(forItem: 0, inSection: proposedDropIndexPath.pointee.section)
        }
        
        // when indexPathsOfItemsBeingDragged == nil, that means theitem is dragged from outside app
        if indexPathsOfItemsBeingDragged == nil {
            return NSDragOperation() // dont accept drop
        } else {
            return NSDragOperation.move
        }
    }
    
    ////////////////////////////////////////////////////
    
    // This is invoked when the user releases the mouse to commit the drop operation.
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        if let itemsDraggedSet = indexPathsOfItemsBeingDragged {
            let itemsDraggedIndexPath = itemsDraggedSet.sorted()
            // Then it falls here when it's a move operation.

            // determine how much the collectionview is going to move
            // cocoa does its destination index path assuming the items arent moved yet
            // i.e, given:
            // A B C
            // and we move A to the spot between B and C
            // cocoa will give destionation index to be 2
            // because when we insert A at index 2, we'll get
            // A B A C
            var sectionMovement = 0
            for fromIndexPath in itemsDraggedIndexPath {
                if fromIndexPath.section == indexPath.section &&
                    fromIndexPath.compare(indexPath) == .orderedAscending {
                    sectionMovement += 1
                }
            }
            var toIndexPath = indexPath
            toIndexPath.item -= sectionMovement
            
            let targetWasEmpty = numberOfItems(inSection: toIndexPath.section) == 0
            
            // update model
            bookmarkDirectory.moveBookmarks(from: itemsDraggedSet, to: toIndexPath)

            var emptySections = Set<Int>()
            for sourceIndexPath in itemsDraggedSet {
                if numberOfItems(inSection: sourceIndexPath.section) == 0 {
                    emptySections.insert(sourceIndexPath.section)
                }
            }
            
            // update collection view in a batch
            collectionView.animator().performBatchUpdates({
                // move the items
                for fromIndexPath in itemsDraggedIndexPath {
                    print("move item from: \(fromIndexPath) to: \(toIndexPath)")
                    collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
                    toIndexPath.item += 1
                }
                
                // reload the target section which was empty to remove the dummy item
                if targetWasEmpty {
                    collectionView.reloadSections([toIndexPath.section])
                }
                
                // reload sources section which are now empty to add dummy item
                for section in emptySections {
                    collectionView.reloadSections([section])
                }
                
            }, completionHandler: nil)
        }
        
        return true
    }
    
    
    // Invoked to conclude the drag session. Clears the value of indexPathsOfItemsBeingDragged.
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        // nothing is being dragged anymore
        indexPathsOfItemsBeingDragged = nil
    }
    
}
