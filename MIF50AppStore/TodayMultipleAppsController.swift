//
//  TodayMultipleAppsController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/28/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListContoller {
    fileprivate let spacing: CGFloat = 16
    fileprivate let multipleAppCellId = "MultipleAppCellId"
    
    var feedResults = [FeedResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: multipleAppCellId)
        
//        fetchData()
        
    }
    
//    private func fetchData() {
//        Service.share.fetchGames { (res) in
//            switch res {
//            case .success(let appGroup):
//                self.feedResults = appGroup.feed.results
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print("TodayMultipleAppsController error \(error)")
//            }
//        }
//    }
}

// MARK: - UICollectionViewDataSource
extension TodayMultipleAppsController {
    
    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return min(4, feedResults.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleAppCellId, for: indexPath) as! MultipleAppCell
        cell.feedResult = feedResults[indexPath.item]
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension TodayMultipleAppsController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (view.frame.height - 3 * spacing) / 4
        return CGSize(width: view.frame.width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
