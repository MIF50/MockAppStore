//
//  MusicController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/13/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class MusicController: BaseListContoller {
    
    fileprivate let tractorCellId = "tractorCellId"
    fileprivate let musicLoadingFooterId = "musicLoadingFooterId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
    }
    
    fileprivate func initCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(TractorCell.self, forCellWithReuseIdentifier: tractorCellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: musicLoadingFooterId)
    }
}

extension MusicController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tractorCellId, for: indexPath) as! TractorCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: musicLoadingFooterId, for: indexPath) as! MusicLoadingFooter
            return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
}

extension MusicController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
}
