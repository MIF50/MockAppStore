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
    
    var appId :String! {
        didSet {
            Service.share.fetchPageDetails(id: appId) {  res in
                switch res {
                case .success(let searchResult):
                    print(searchResult.results.first?.releaseNotes ?? "")
                case .failure(let error ):
                    print("error \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.largeTitleDisplayMode = .never
    }
    

    

    
    
}

// MARK: - UICollectionViewDataSource
extension AppDetailsController {
    //1
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    //3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppDetailCell
        // Configure the cell
        return cell
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension AppDetailsController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
        
    }
    
}
