//
//  AppsHeaderHorizontalController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/7/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsHeaderHorizontalVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let layout = BetterSnapingLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.decelerationRate = .fast
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
        
    private let handler = AppHeaderHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func addSocialApps(apps: [SocialApp]) {
        handler.setup(collectionView)
        handler.indexData = apps
        collectionView.reloadData()
    }
}

class AppHeaderHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    fileprivate let cellId = "cellId"

    var indexData = [SocialApp]()
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    // number of items in section in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexData.count
    }
    /// resuse cell for item at index path in collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsHeaderCell
        cell.socialApp = indexData[indexPath.item]
        return cell
    }
    /// return width and height of  in collection view cell size for item at index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 40 , height: collectionView.frame.height)
    }
}

///  to preview desing form SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AppsHeaderHorizontalController_Preview : PreviewProvider {
    
    static var previews: some View {
         ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable  {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AppsHeaderHorizontalController_Preview.ContainerView>) -> UIViewController {
            return AppsHeaderHorizontalVC()
        }
        
        func updateUIViewController(_ uiViewController: AppsHeaderHorizontalController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AppsHeaderHorizontalController_Preview.ContainerView>) {
            
        }
    }
}


#endif
