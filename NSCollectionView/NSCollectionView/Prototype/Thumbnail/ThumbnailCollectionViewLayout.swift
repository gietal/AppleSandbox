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
                    currentY += itemSize.height + itemSpacing.height
                }
                
                // put an item here
                let itemAttribute = NSCollectionViewLayoutAttributes(forItemWith: IndexPath(item: itemId, section: sectionId))
                itemAttribute.frame = CGRect(origin: CGPoint(x: currentX, y: currentY), size: itemSize)
                cachedAttributes.append(itemAttribute)
                
                // cache the index
                indexPathToAttributeIndex[IndexPath(item: itemId, section: sectionId)] = cachedAttributes.count - 1
                
                // advance position
                itemIndexInRow += 1
                currentX += itemSize.width + itemSpacing.width
            }
            if cv.numberOfItems(inSection: sectionId) > 0 {
                // last row is done ( if any)
                currentY += itemSize.height + itemSpacing.height
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
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        // get all the attributes that intersects with the given rect
        return cachedAttributes.filter {
            return rect.intersects($0.frame)
        }
    }
}
