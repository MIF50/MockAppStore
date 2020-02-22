//
//  TodayController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/22/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class TodayController: BaseListContoller {
    
    fileprivate let todayCellId = "todayCellId"
    
    var startingFrame: CGRect?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.backgroundColor = #colorLiteral(red: 0.9410567326, green: 0.9410567326, blue: 0.9410567326, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: todayCellId)
    }
}


// MARK: - UICollectionViewDataSource
extension TodayController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let redView = UIView()
        redView.backgroundColor = .red
        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(redView)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // absolute coordinate for cell
        guard let startFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        startingFrame = startFrame
        redView.frame = startFrame
        redView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            redView.frame = self.view.frame
        }, completion: nil)
    }
    
    @objc func handleRemoveRedView(gesture : UITapGestureRecognizer) {
        // access startingFrame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            gesture.view?.frame = self.startingFrame ?? .zero
        }, completion: { _ in
            gesture.view?.removeFromSuperview()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayCellId, for: indexPath) as! TodayCell
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension TodayController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 48 , height: 450)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
