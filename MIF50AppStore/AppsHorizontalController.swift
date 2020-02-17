//
//  AppsHorizontalController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/3/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var appGroup: AppGroup?
    
    let topBottomPadding: CGFloat = 12
    let leftRightPadding: CGFloat = 16
    let lineSpacing: CGFloat = 10
    
    var didSelectHandler: ((FeedResult)-> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        // register collection view
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: topBottomPadding, left: leftRightPadding, bottom: topBottomPadding, right: leftRightPadding)

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appGroup?.feed.results[indexPath.item] {
            didSelectHandler?(app)
        }
    }
    
    /// return number of item in collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroup?.feed.results.count ?? 0
    }
  
    /// use register UICollectionViewCell and reusable for collection view and pass data for it
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
        let feedResult = appGroup?.feed.results[indexPath.item]
        cell.feedResult = feedResult
        return cell
    }
    
    /// use to set width and height of cell in collection view  --- implement of UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.frame.height - topBottomPadding * 2  - lineSpacing * 2) / 3
        return .init(width: collectionView.frame.width - 40, height: height)
    }
    /// set min line space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
//    /// inset padding for collection view
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .init(top: topBottomPadding, left: leftRightPadding, bottom: topBottomPadding, right: leftRightPadding)
//    }
}
