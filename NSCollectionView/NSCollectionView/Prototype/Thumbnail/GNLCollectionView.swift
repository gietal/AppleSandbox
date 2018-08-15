//
//  GNLCollectionView.swift
//  NSCollectionView
//
//  Created by gietal-dev on 31/07/18.
//  Copyright © 2018 gietal-dev. All rights reserved.
//

import Foundation
import Cocoa
class GNLCollectionView: NSCollectionView {
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let superOutput = super.draggingEntered(sender)
        return superOutput
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        let superOutput = super.draggingUpdated(sender)
//        return superOutput
        return .move
    }
}
