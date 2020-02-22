//
//  AppDetailsController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/15/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppDetailsController : BaseListContoller {
    /// resuable cell ids
    fileprivate let appDetailCell = "AppDetailCell"
    fileprivate let screenshotRowCell = "screenshotRowCell"
    fileprivate let previewRowCell = "previewRowCell"
    
    fileprivate var app: ResultApp?
    fileprivate var preview: Preview?
    
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
            
            Service.share.fetchPreviewsAndRating(id: appId) { (res) in
                switch res {
                case .success(let preview) :
                    self.preview = preview
                case .failure(let error):
                    print("PreivewController Error \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never

        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: appDetailCell)
        collectionView.register(ScreenshotRowCell.self, forCellWithReuseIdentifier: screenshotRowCell)
        collectionView.register(PreviewRowCell.self, forCellWithReuseIdentifier: previewRowCell)
    }
    

    

    
    
}

// MARK: - UICollectionViewDataSource
extension AppDetailsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailCell, for: indexPath) as! AppDetailCell
            if let app = app {
                cell.appResult = app
            }
            return cell
        } else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotRowCell, for: indexPath) as! ScreenshotRowCell
            if let app = app {
                cell.horizontalPreviewScreenshotController.app = app
            }
            return cell
        } else {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: previewRowCell, for: indexPath) as! PreviewRowCell
            cell.horizontalPrviewController.preview = preview
            
            return cell
        }
        
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension AppDetailsController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 280
        if indexPath.item == 0 {
            // calculate the nesessary size for our cell somehowe
            let dummyCell = AppDetailCell.init(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            if let app = app {
                dummyCell.appResult = app
            }
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        } else if indexPath.item == 1 {
            height = 500
        } else {
            height = 280
        }
        return .init(width: view.frame.width, height: height)
        
    }
    
}
