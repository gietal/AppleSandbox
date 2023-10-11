//
//  ThumbnailCollectionViewLayout.swift
//  NSCollectionView
//
//  Created by gietal-dev on 7/17/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa

protocol ThumbnailCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, headerHeightForSection section: Int ) -> CGFloat
}

class ThumbnailCollectionViewLayout: NSCollectionViewFlowLayout {
    
    // attributes similar to flow layout
    open var originalItemSize = CGSize.zero
    open var itemSpacing = CGSize.zero
//    open var sectionInset = NSEdgeInsetsZero
    open var delegate: ThumbnailCollectionViewLayoutDelegate?
    open var fillGapByEnlargingItems = true
    open var maxEnlargingFactor: CGFloat = 1.3
    
    private var indexPathToAttributeIndex = [IndexPath: Int]()
    private var contentBounds = CGRect.zero
    private var cachedAttributes = [NSCollectionViewLayoutAttributes]()
    private var sectionIndexToAttributedIndex = [Int]()
    private var dropTargetAreas = [IndexPath: CGRect]()
    private var actualItemSize = CGSize.zero
    
    override func prepare() {
        // called everytime layout is invalidated
        // compute collectionview content size
        
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        
        // reset cache
        cachedAttributes.removeAll()
        indexPathToAttributeIndex.removeAll()
        sectionIndexToAttributedIndex.removeAll()
        dropTargetAreas.removeAll()
        contentBounds = CGRect(origin: CGPoint.zero, size: cv.bounds.size)
        
        createAttributes()
    }
    
    fileprivate func createAttributes() {
        guard let cv = collectionView, let delegate = delegate else {
            return
        }
        
        // get section count
        // for each section
        //   get header height
        //   get item count
        //   foreach item
        //     get item size
        var currentY: CGFloat = 0
        var currentX: CGFloat = 0
        let leftEdge = sectionInset.left
        let rightEdge = contentBounds.width - sectionInset.right
        
        // calculate item per row
        var itemPerRow = (Int)((contentBounds.width - sectionInset.left - sectionInset.right) / (originalItemSize.width + itemSpacing.width))
        
        if (rightEdge - (leftEdge + CGFloat(itemPerRow) * (originalItemSize.width + itemSpacing.width))) > originalItemSize.width {
            itemPerRow += 1
        }
        
        if itemPerRow == 0 {
            return
        }
        
        // reset actual item size
        actualItemSize = originalItemSize
        
        // determine if there's any gap
        if fillGapByEnlargingItems {
            // only enlarge items when at least 1 section has items more than the itemPerRow
            var doEnlarge = true
//            for sectionId in 0..<cv.numberOfSections {
//                if cv.numberOfItems(inSection: sectionId) > itemPerRow {
//                    doEnlarge = true
//                    break
//                }
//            }
            var percentMultiplierPerItem: CGFloat = 1
            if doEnlarge {
                let itemsRowWidth = (originalItemSize.width * CGFloat(itemPerRow)) + (itemSpacing.width * CGFloat(itemPerRow - 1))
                let gap: CGFloat = rightEdge - (leftEdge + itemsRowWidth)
                let gapPerItem = (gap / CGFloat(itemPerRow))
                percentMultiplierPerItem = min(maxEnlargingFactor, (gapPerItem / originalItemSize.width) + 1)
                
            }
            actualItemSize.width = actualItemSize.width * percentMultiplierPerItem
            actualItemSize.height = actualItemSize.height * percentMultiplierPerItem
        }
        
        for sectionId in 0..<cv.numberOfSections {
            
            let headerHeight = delegate.collectionView(cv, layout: self, headerHeightForSection: sectionId)
            let headerAttribute = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: .sectionHeader, with: IndexPath(item: 0, section: sectionId))
            headerAttribute.frame = CGRect(x: 0, y: currentY, width: contentBounds.width, height: headerHeight)
            
            let ori = headerAttribute.frame
//            headerAttribute.frame = CGRect(x: ori.minX - 50, y: ori.minY, width: ori.width + 100, height: ori.height - 10)
            headerAttribute.zIndex = 10
            headerAttribute.alpha = 1
            headerAttribute.isHidden = false
            
//            headerAttribute.z
            cachedAttributes.append(headerAttribute)
            sectionIndexToAttributedIndex.append(cachedAttributes.count-1)
            
            // advance Y
            currentY += headerHeight
            
            // add top section inset
//            currentY += sectionInset.top
            
            // reset x position
            currentX = leftEdge
            
            var itemIndexInRow = 0
            for itemId in 0..<cv.numberOfItems(inSection: sectionId) {
                if itemIndexInRow == itemPerRow {
                    itemIndexInRow = 0
                    
                    // add a drop target area to allow dropping after the last item on a row
                    let dropSectionX = currentX - itemSpacing.width
                    dropTargetAreas[IndexPath(item: itemId, section: sectionId)] = CGRect(x: dropSectionX , y: currentY, width: actualItemSize.width, height: actualItemSize.height)
                    
                    // reset x position
                    currentX = leftEdge
                    
                    // advance y position
                    currentY += actualItemSize.height + itemSpacing.height
                }
                
                // put an item here
                let itemAttribute = NSCollectionViewLayoutAttributes(forItemWith: IndexPath(item: itemId, section: sectionId))
                itemAttribute.frame = CGRect(origin: CGPoint(x: currentX, y: currentY), size: actualItemSize)
                cachedAttributes.append(itemAttribute)
                
                // cache the index
                indexPathToAttributeIndex[IndexPath(item: itemId, section: sectionId)] = cachedAttributes.count - 1
                
                // advance position
                itemIndexInRow += 1
                currentX += actualItemSize.width + itemSpacing.width
            }
            
            if cv.numberOfItems(inSection: sectionId) > 0 {
                
                // add a drop target area to allow dropping after the last item on the section
                dropTargetAreas[IndexPath(item: cv.numberOfItems(inSection: sectionId), section: sectionId)] = CGRect(x: currentX, y: currentY, width: rightEdge - currentX, height: actualItemSize.height)
                
                // last row is done ( if any)
                currentY += actualItemSize.height + itemSpacing.height
            }
            
            
            // add bottom section inset
            currentY += sectionInset.bottom
        }
        
        contentBounds.size = CGSize(width: contentBounds.width, height: currentY)
    }
    
    override var collectionViewContentSize: NSSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        // called during scrolling
        
        guard let cv = collectionView else {
            return false
        }
        
        // only invalidate when the size changes
        return newBounds.size != contentBounds.size
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        if elementKind != .sectionHeader {
//            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
            return nil
        }
        
        // properly give the correct attribute for the section header
        let index = sectionIndexToAttributedIndex[indexPath.section]
        let attribute = cachedAttributes[index]
//        let ori = attribute.frame
//        attribute.frame = CGRect(x: ori.minX + 5, y: ori.minY + 5, width: ori.width - 10, height: ori.height - 10)
        return attribute
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        if let index = indexPathToAttributeIndex[indexPath] {
            return cachedAttributes[index]
        }
        return nil
    }
    
    override func layoutAttributesForInterItemGap(before indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        if let index = indexPathToAttributeIndex[indexPath] {
            // gap is before the item
            let itemAttribute = cachedAttributes[index]
            let gapAttribute = NSCollectionViewLayoutAttributes(forInterItemGapBefore: indexPath)
            gapAttribute.frame.origin = CGPoint(x: itemAttribute.frame.minX - itemSpacing.width, y: itemAttribute.frame.minY)
            gapAttribute.frame.size = CGSize(width: itemSpacing.width, height: itemAttribute.frame.height)
            return gapAttribute
        } else if let index = indexPathToAttributeIndex[IndexPath(item: indexPath.item-1, section: indexPath.section)] {
            // gap is after the item (only happen at the end of collection view)
            // so we create an inter item gap after the last item all the way to the right-most side of the collection
            let itemAttribute = cachedAttributes[index]
            let gapAttribute = NSCollectionViewLayoutAttributes(forInterItemGapBefore: indexPath)
            gapAttribute.frame.origin = CGPoint(x: itemAttribute.frame.minX + itemAttribute.frame.width, y: itemAttribute.frame.minY)
            gapAttribute.frame.size = CGSize(width: itemSpacing.width, height: itemAttribute.frame.height)
            return gapAttribute
        }
        return nil
    }
    
    override func layoutAttributesForDropTarget(at pointInCollectionView: NSPoint) -> NSCollectionViewLayoutAttributes? {
        guard let cv = collectionView else {
            return nil
        }
        
        // let super find a suitable drop target if possible
        if let dropAttribute = super.layoutAttributesForDropTarget(at: pointInCollectionView) {
            return dropAttribute
        }
        
        // otherwise, check all our extra drop targets
        if let kvp = dropTargetAreas.filter( { (_, areaRect) -> Bool in
            return areaRect.contains(pointInCollectionView)
        }).first {
            return NSCollectionViewLayoutAttributes(forInterItemGapBefore: kvp.key)
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        // get all the attributes that intersects with the given rect
        return cachedAttributes.filter {
            return rect.intersects($0.frame)
        }
    }
}

class DebugFlowLayout: NSCollectionViewFlowLayout {
    override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        
        return attribute
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForItem(at: indexPath)
        
        return attribute
    }
    
    override func layoutAttributesForInterItemGap(before indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForInterItemGap(before: indexPath)
        
        return attribute
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        return attributes
    }
    
    public var originalItemSize = CGSize(width: 200, height: 145)
    public var maxEnlargingFactor: CGFloat = 2
    open var itemSpacing = CGSize(width: 7, height: 7)
    private var contentBounds = CGRect.zero
    
    override func prepare() {
        
        super.prepare()
    }
//    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
//        contentBounds = collectionView!.enclosingScrollView!.bounds
//        self.minimumInteritemSpacing = itemSpacing.width
//        self.minimumLineSpacing = itemSpacing.height
//
//        // calculate item per row
//        var itemPerRow = (Int)((contentBounds.width - sectionInset.left - sectionInset.right) / (originalItemSize.width + itemSpacing.width))
//        let rightEdge = contentBounds.width - sectionInset.right
//        let leftEdge = sectionInset.left
//
//        if (rightEdge - (leftEdge + CGFloat(itemPerRow) * (originalItemSize.width + itemSpacing.width))) > originalItemSize.width {
//            itemPerRow += 1
//        }
//
//        if itemPerRow == 0 {
//            return true
//        }
//
////        if doEnlarge {
//            let itemsRowWidth = (originalItemSize.width * CGFloat(itemPerRow)) + (itemSpacing.width * CGFloat(itemPerRow - 1))
//            let gap: CGFloat = rightEdge - (leftEdge + itemsRowWidth)
//            let gapPerItem = (gap / CGFloat(itemPerRow))
//            var percentMultiplierPerItem = min(maxEnlargingFactor, (gapPerItem / originalItemSize.width) + 1)
////        }
//
//
//        originalItemSize.width = originalItemSize.width * percentMultiplierPerItem
//
//        // looks like Cocoa has an issue rendering non fixed-point images
//        // we only round the height, as the artifact is very pronounced on the vertical axis
//        originalItemSize.height = (originalItemSize.height * percentMultiplierPerItem).rounded(.toNearestOrEven)
//
//        print("new multiplier: \(percentMultiplierPerItem), new itemsize: \(originalItemSize)")
//
//        return true
//    }
}
