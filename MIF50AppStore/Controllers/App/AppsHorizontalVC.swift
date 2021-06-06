//
//  AppsHorizontalController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/3/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsHorizontalVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let layout = BetterSnapingLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.decelerationRate = .fast
        return collection
    }()
    
    
    var appGroup: AppGroup? {
        didSet {
            handler.indexData = appGroup
            collectionView.reloadData()
        }
    }
    var didSelectHandler: ((FeedResult)-> ())?
    
    private let handler = AppsHorizontalHandler()
    
    let topBottomPadding: CGFloat = 12
    let leftRightPadding: CGFloat = 16


    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: topBottomPadding, left: leftRightPadding, bottom: topBottomPadding, right: leftRightPadding)
        handler.setup(collectionView)
        handler.didSelect = { [weak self] feedResult in
            self?.didSelectHandler?(feedResult)
        }
    }
    
}

// MARK:- AppsHorizontalHandler
class AppsHorizontalHandler: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let cellId = "cellId"
    
    let topBottomPadding: CGFloat = 12
    let leftRightPadding: CGFloat = 16
    let lineSpacing: CGFloat = 10

    var indexData: AppGroup?
    var didSelect: ((FeedResult)-> ())?

    func setup(_ collectoinView: UICollectionView) {
        collectoinView.delegate  = self
        collectoinView.dataSource = self
        collectoinView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = indexData?.feed.results[indexPath.item] {
            didSelect?(app)
        }
    }
    
    /// return number of item in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexData?.feed.results.count ?? 0
    }
  
    /// use register UICollectionViewCell and reusable for collection view and pass data for it
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
        let feedResult = indexData?.feed.results[indexPath.item]
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
}


///  to preview desing form SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AppsHorizontalController_Preview : PreviewProvider {
    
    static var previews: some View {
         ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable  {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AppsHorizontalController_Preview.ContainerView>) -> UIViewController {
            return AppsHorizontalVC()
        }
        
        func updateUIViewController(_ uiViewController: AppsHorizontalController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AppsHorizontalController_Preview.ContainerView>) {
        }
    }
}
#endif
