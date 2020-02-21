//
//  AppDetailsController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/15/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppDetailsController : BaseListContoller {
    
    fileprivate let cellId = "AppDetailCell"
    fileprivate let previewCell = "PreviewCell"
    
    fileprivate var app: ResultApp?
    
    var appId :String! {
        didSet {
            Service.share.fetchPageDetails(id: appId) {  res in
                switch res {
                case .success(let searchResult):
                    self.app = searchResult.results.first
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error ):
                    print("error \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never

        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCell)
    }
    

    

    
    
}

// MARK: - UICollectionViewDataSource
extension AppDetailsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppDetailCell
            if let app = app {
                cell.appResult = app
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCell, for: indexPath) as! PreviewCell
            if let app = app {
                cell.horizontalPreviewScreenshotController.app = app
            }
            return cell
        }
        
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension AppDetailsController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            // calculate the nesessary size for our cell somehowe
                   let dummyCell = AppDetailCell.init(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
                   if let app = app {
                       dummyCell.appResult = app
                   }
                   dummyCell.layoutIfNeeded()
                   
                   let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
                   return .init(width: view.frame.width, height: estimatedSize.height)
        } else {
            return .init(width: view.frame.width, height: 500)
        }
        
       
        
    }
    
}
