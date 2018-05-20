//
//  ThumbnailViewController.swift
//  NSCollectionView
//
//  Created by Gieta Laksmana on 5/19/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

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
    
    fileprivate func setupLayout() {
        // setup the layout
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        // 2
        view.wantsLayer = true
        collectionView.wantsLayer = true
        // 3
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
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
    func directoryReloaded() {
        collectionView.reloadData()
    }
}

extension BookmarkThumbnailViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return bookmarkDirectory.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkDirectory.numberOfItemsInSection(section)
    }
    
    // used to create collection view item
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        // create the view item
        let viewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkThumbnailViewItem"), for: indexPath) as! BookmarkThumbnailViewItem

        // put our model in
        let bookmark = bookmarkDirectory.bookmark(for: indexPath)
        viewItem.bookmark = bookmark
        return viewItem
    }
    
    // used to create header/footer/interimgap section
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        var view: NSView
        if kind == .sectionHeader {
            // create header and  put our model in
            let headerView = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkThumbnailHeaderView"), for: indexPath) as! BookmarkThumbnailHeaderView
            headerView.group = bookmarkDirectory.bookmarkGroup(for: indexPath)
            view = headerView
        } else {
            // non header, make nil view
            view = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: ""), for: indexPath)
            
        }
        
        return view
    }
}

extension BookmarkThumbnailViewController: NSCollectionViewDelegateFlowLayout {
    // determine the size of the header
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 100, height: 40)
    }
}

extension BookmarkThumbnailViewController: NSCollectionViewDelegate {
    
    //////// this part, allows the collectionview to act as Drag Source, so items can bepicked up from ////////
    
    // allow dragging item
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
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
        
        // this makes sure that when user try to drop items on to another item, we make it so that it drops before the item
        if proposedDropOperation.pointee == NSCollectionView.DropOperation.on {
            proposedDropOperation.pointee = NSCollectionView.DropOperation.before
        }
        
        // when indexPathsOfItemsBeingDragged == nil, that means theitem is dragged from outside app
        if indexPathsOfItemsBeingDragged == nil {
            return NSDragOperation.copy
        } else {
            return NSDragOperation.move
        }
    }
    
    ////////////////////////////////////////////////////
    
    // This is invoked when the user releases the mouse to commit the drop operation.
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        if let itemsDraggedIndexPath = indexPathsOfItemsBeingDragged {
            // Then it falls here when it's a move operation.

            // update the model
//            bookmarkDirectory.moveBookmark(from: itemsDraggedIndexPath, to: toIndexPath)
            // notify collectionview
            for fromIndexPath in itemsDraggedIndexPath {
                var toIndexPath = indexPath
                
                // cocoa does its destination index path assuming the items arent moved yet
                // i.e, given:
                // A B C
                // and we move A to the spot between B and C
                // cocoa will give destionation index to be 2
                // because when we insert A at index 2, we'll get
                // A B A C
                if fromIndexPath.section == toIndexPath.section &&
                    fromIndexPath.compare(toIndexPath) == .orderedAscending {
                    toIndexPath.item -= 1
                }
                bookmarkDirectory.moveBookmark(from: fromIndexPath, to: toIndexPath)
                collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
            }
            
        }
        return true
    }
    
    // Invoked to conclude the drag session. Clears the value of indexPathsOfItemsBeingDragged.
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        // nothing is being dragged anymore
        indexPathsOfItemsBeingDragged = nil
    }
    
}
