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
        collectionView.registerForDraggedTypes([.URL])
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
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookmarkThumbnailViewItem"), for: indexPath)
        guard let viewItem = item as? BookmarkThumbnailViewItem else {
            return item
        }
        
        // 5
        let bookmark = bookmarkDirectory.bookmark(for: indexPath)
        viewItem.bookmark = bookmark
        return item
    }
    
    // used to create header/footer/interimgap section
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        var view: NSView
        if kind == .sectionHeader {
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
