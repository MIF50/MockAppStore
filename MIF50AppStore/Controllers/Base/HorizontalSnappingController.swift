//
//  HorizontalSnappingController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/14/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {
    
    init() {
        let layout = BetterSnapingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SnappingLayout: UICollectionViewFlowLayout {
    /// snap behavior
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        // we are using a megical 40 
        let itemWidth = collectionView.frame.width - 40
        let itemSpace = itemWidth + minimumInteritemSpacing
        var pageNumber = round(collectionView.contentOffset.x / itemSpace)
        
        // Skip to the next cell, if there is residual scrolling velocity left.
        // This helps to prevent glitches
        let vX = velocity.x
        print("velocit x = \(vX), page number before \(pageNumber)")
        if vX > 0 {
            pageNumber += 1
        } else if vX < 0 {
            pageNumber -= 1
        }
        
        print("page number after = \(pageNumber), itemSpace = \(itemSpace)")
        let nearestPageOffset = pageNumber * itemSpace
        print(" nearestPageOffset \(nearestPageOffset)")

        return CGPoint(x: nearestPageOffset, y: parent.y)
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView = self.collectionView else {
//            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//        }
//        // here some confusing math that i don't really want to explaing ...
//
//        let itemWidth = collectionView.frame.width - 40
//        let pageNumber = collectionView.contentOffset.x / itemWidth
//
//        print("page number = \(round(pageNumber))")
//
//        return CGPoint(x: pageNumber * itemWidth, y: 0)
//    }
    
}
