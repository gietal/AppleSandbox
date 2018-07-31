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

class ThumbnailCollectionViewLayout: NSCollectionViewLayout {
    
    // attributes similar to flow layout
    open var itemSize = CGSize.zero
    open var itemSpacing = CGSize.zero
    open var sectionInset = NSEdgeInsetsZero
    open var delegate: ThumbnailCollectionViewLayoutDelegate?
    open var fillGapByEnlargingItems = true
    open var maxEnlargingFactor: CGFloat = 1.3
    
    private var indexPathToAttributeIndex = [IndexPath: Int]()
    private var contentBounds = CGRect.zero
    private var cachedAttributes = [NSCollectionViewLayoutAttributes]()
    
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
        var itemPerRow = (Int)((contentBounds.width - sectionInset.left - sectionInset.right) / (itemSize.width + itemSpacing.width))
        
        if (rightEdge - (leftEdge + CGFloat(itemPerRow) * (itemSize.width + itemSpacing.width))) > itemSize.width {
            itemPerRow += 1
        }
        
        if itemPerRow == 0 {
            return
        }
        var actualItemSize = itemSize
        
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
                let itemsRowWidth = (itemSize.width * CGFloat(itemPerRow)) + (itemSpacing.width * CGFloat(itemPerRow - 1))
                let gap: CGFloat = rightEdge - (leftEdge + itemsRowWidth)
                let gapPerItem = (gap / CGFloat(itemPerRow))
                percentMultiplierPerItem = min(maxEnlargingFactor, (gapPerItem / itemSize.width) + 1)
                
            }
            actualItemSize.width = actualItemSize.width * percentMultiplierPerItem
            actualItemSize.height = actualItemSize.height * percentMultiplierPerItem
        }
        
        for sectionId in 0..<cv.numberOfSections {
            
            let headerHeight = delegate.collectionView(cv, layout: self, headerHeightForSection: sectionId)
            let headerAttribute = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: .sectionHeader, with: IndexPath(item: 0, section: sectionId))
            headerAttribute.frame = CGRect(x: 0, y: currentY, width: contentBounds.width, height: headerHeight)
            cachedAttributes.append(headerAttribute)
            
            // advance Y
            currentY += headerHeight
            
            // add top section inset
            currentY += sectionInset.top
            
            // reset x position
            currentX = leftEdge
            
            var itemIndexInRow = 0
            for itemId in 0..<cv.numberOfItems(inSection: sectionId) {
                if itemIndexInRow == itemPerRow {
                    itemIndexInRow = 0
                    
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
                
                // put an interitem gap before this item
                var gapAttribute = NSCollectionViewLayoutAttributes(forInterItemGapBefore: IndexPath(item: itemId, section: sectionId))
                gapAttribute.frame = CGRect(origin: CGPoint(x: currentX - itemSpacing.width, y: currentY), size: CGSize(width: itemSpacing.width, height: actualItemSize.height))
                cachedAttributes.append(gapAttribute)
                
                // advance position
                itemIndexInRow += 1
                currentX += actualItemSize.width + itemSpacing.width
            }
            if cv.numberOfItems(inSection: sectionId) > 0 {
                
                // add inter item gap after the last item
                var gapAttribute = NSCollectionViewLayoutAttributes(forInterItemGapBefore: IndexPath(item: 0, section: sectionId + 1))
                gapAttribute.frame = CGRect(origin: CGPoint(x: currentX - itemSpacing.width, y: currentY), size: CGSize(width: itemSpacing.width, height: actualItemSize.height))
                cachedAttributes.append(gapAttribute)
                
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
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        if let index = indexPathToAttributeIndex[indexPath] {
            return cachedAttributes[index]
        }
        return nil
    }
    
    override func layoutAttributesForInterItemGap(before indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        if let index = indexPathToAttributeIndex[indexPath] {
            return cachedAttributes[index + 1] // interitem gap is always after the item
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
