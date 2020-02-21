//
//  PeviewsControllers.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class PreviewsContoller: HorizontalSnappingController {
    fileprivate let previewCellId = "previewCellId"
    
    var appId: String! {
        didSet {
            Service.share.fetchPreviewsAndRating(id: appId) { (res) in
                switch res {
                case .success(let preview) :
                    print("preview and rating \(preview)")
                case .failure(let error):
                    print("PreivewController Error \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 20, right: 20)
    }
}

// MARK: - UICollectionViewDataSource
extension PreviewsContoller {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
        
        return cell
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension PreviewsContoller : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width - 48, height: view.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
