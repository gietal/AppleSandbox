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
    override func viewDidLoad() {
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
        
        imageDirectory.singleSectionMode = false
        imageDirectory.loadDataForFolderWithUrl(URL(string: "/Users/gietal-dev/Desktop")!)
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
    
    // used to create header/footer section
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        // 1
        let view = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GridHeaderView"), for: indexPath) as! GridHeaderView
        // 2
        view.sectionTitle.stringValue = "Section \(indexPath.section)"

        return view
    }
}

extension GridViewController: NSCollectionViewDelegateFlowLayout {
    // determine the size of the header
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 100, height: 40)
    }
}
