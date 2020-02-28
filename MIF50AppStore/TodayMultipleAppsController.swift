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
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return btn
    }()
    
    @objc private func handleDismiss(){
        dismiss(animated: true)
    }
    
    var feedResults = [FeedResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: multipleAppCellId)
        
        
    }
    
    private func initView(){
        if mode == .fullscreen {
            setupCloseBtn()
        } else {
            collectionView.isScrollEnabled = false
        }
        collectionView.backgroundColor = .white
    }
    
    private func setupCloseBtn() {
        view.addSubview(closeBtn)
        closeBtn.anchor(
            top: view.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 20)
            ,size: .init(width: 44, height: 44))
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    fileprivate var mode : Mode
    
     init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Mode: String {
        case small, fullscreen
    }
    
}

// MARK: - UICollectionViewDataSource
extension TodayMultipleAppsController {
    
    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        if mode == .fullscreen {
            return feedResults.count
        }
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
        if mode == .fullscreen {
            return CGSize(width: view.frame.width - 48 , height: 67)
        }
        let height: CGFloat = (view.frame.height - 3 * spacing) / 4
        return CGSize(width: view.frame.width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return .init(top: 16, left: 24, bottom: 16, right: 24)
        } else {
            return .zero
        }
    }
}
