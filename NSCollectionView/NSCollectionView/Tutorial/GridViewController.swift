//
//  GridViewController.swift
//  NSCollectionView
//
//  Created by gietal-dev on 5/14/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa


class GridViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var label: NSTextField!
    var imageDirectory = ImageDirectoryLoader()
    var indexPathsOfItemsBeingDragged: Set<IndexPath>!
    
    override func viewDidLoad() {
        setupLayout()
        setupDragAndDrop()
        setupImageDirectory()
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
        label.stringValue = "hello"
        
        // register xibs
        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CollectionViewItem"), bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue:"CollectionViewItem"))
        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: "GridHeaderView"), bundle: nil), forSupplementaryViewOfKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue:"GridHeaderView"))
        
    }
    
    fileprivate func setupDragAndDrop(){
        collectionView.registerForDraggedTypes([.URL])
        collectionView.setDraggingSourceOperationMask(.every, forLocal: true)
    }
    
    fileprivate func setupImageDirectory() {
        imageDirectory.singleSectionMode = false
        imageDirectory.loadDataForFolderWithUrl(URL(string: "/Users/gietal/Desktop")!)
    }
}

extension GridViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return imageDirectory.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectory.numberOfItemsInSection(section)
    }
    
    // used to create collection view item
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        // 5
        let imageFile = imageDirectory.imageFileForIndexPath(indexPath)
        collectionViewItem.imageFile = imageFile
        return item
    }
    
    // used to create header/footer/interimgap section
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        var view: NSView
        if kind == .sectionHeader {
            let headerView = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GridHeaderView"), for: indexPath) as! GridHeaderView
            headerView.sectionTitle.stringValue = "Section \(indexPath.section)"
            view = headerView
        } else {
            // non header, make nil view
            view = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: ""), for: indexPath)
            
        }
        
        return view
    }
}

extension GridViewController: NSCollectionViewDelegateFlowLayout {
    // determine the size of the header
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 100, height: 40)
    }
}

extension GridViewController: NSCollectionViewDelegate {
    
    //////// this part, allows the collectionview to act as Drag Source, so items can bepicked up from ////////
    
    // allow dragging item
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    // this is for multi section
    // thiswill be called per item dragged. we need to return pasteboard writer that represents our underlying object model
    // in this  case  just an NSURL. for bookmark can be id as NSString i guess?
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        let imageFile = imageDirectory.imageFileForIndexPath(indexPath)
        return imageFile.nsUrl
    }
    
    // this is for single section
//    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
//
//    }
    
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
        if indexPathsOfItemsBeingDragged != nil {
            // Then it falls here when it's a move operation.
            let indexPathOfFirstItemBeingDragged = indexPathsOfItemsBeingDragged.first!
            var toIndexPath: IndexPath
            if indexPathOfFirstItemBeingDragged.compare(indexPath) == .orderedAscending {
                toIndexPath = IndexPath(item: indexPath.item-1, section: indexPath.section)
            } else {
                toIndexPath = IndexPath(item: indexPath.item, section: indexPath.section)
            }
            // update the model
            imageDirectory.moveImageFromIndexPath(indexPathOfFirstItemBeingDragged, toIndexPath: toIndexPath)
            // notify collectionview
            collectionView.moveItem(at: indexPathOfFirstItemBeingDragged, to: toIndexPath)
        } else {
            // It falls here to accept a drop from another app.
//            var droppedObjects = Array<NSURL>()
//            draggingInfo.enumerateDraggingItemsWithOptions(NSDraggingItemEnumerationOptions.Concurrent, forView: collectionView, classes: [NSURL.self], searchOptions: [NSPasteboardURLReadingFileURLsOnlyKey : NSNumber(bool: true)]) { (draggingItem, idx, stop) in
//                if let url = draggingItem.item as? NSURL {
//                    droppedObjects.append(url)
//                }
//            }
//            // 6
//            insertAtIndexPathFromURLs(droppedObjects, atIndexPath: indexPath)
        }
        return true
    }
    
    // Invoked to conclude the drag session. Clears the value of indexPathsOfItemsBeingDragged.
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        // nothing is being dragged anymore
        indexPathsOfItemsBeingDragged = nil
    }

}

