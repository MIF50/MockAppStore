//
//  AppsPageVC.swift
//  MIF50AppStore
//
//  Created by MIF50 on 06/06/2021.
//  Copyright © 2021 MIF50. All rights reserved.
//

import UIKit

class AppsPageVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // create load indicator
    let activityIndicatorView : UIActivityIndicatorView = {
        let avi = UIActivityIndicatorView(style: .large)
        avi.color = .black
        avi.startAnimating()
        avi.hidesWhenStopped = true
        return avi
    }()
    
    // MARK:- Handler
    private let handler = AppsPageHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureActivityindicator()
        fetchApps()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        handler.setup(collectionView)
        handler.didTapHeader = { feedResult in
            let controller = AppDetailsController(appId: feedResult.id)
            controller.title = feedResult.name
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func configureActivityindicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    fileprivate func fetchApps(){
        // help you sync your data feches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        APIServices.share.fetchGames { response in
            dispatchGroup.leave()
            switch response {
            case .success(let appGoup):
                self.handler.groups.append(appGoup)
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        APIServices.share.fetchTopGrossing { response in
            dispatchGroup.leave()
            switch response {
            case .success(let appGroup):
                self.handler.groups.append(appGroup)
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        APIServices.share.fetchTopFree { response in
            dispatchGroup.leave()
            switch response {
            case .success(let appGroup):
                self.handler.groups.append(appGroup)
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        APIServices.share.fetchSocialApp { response in
            dispatchGroup.leave()
            switch response {
            case .success(let socialApps):
                self.handler.socialApps = socialApps
            case .failure(let error):
                print(error)
            }
        }
        
        // completion
        dispatchGroup.notify(queue: .main){
            print("dispathGroup.notify")
            self.activityIndicatorView.stopAnimating()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK:- AppsPageHandler
class AppsPageHandler: NSObject,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- CellIds
    fileprivate let cellId = "cell"
    fileprivate let headerId = "headerId"
    
    var groups = [AppGroup]()
    var socialApps = [SocialApp]()
    var didTapHeader:((FeedResult)->Void)?
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        /// step 1 for header - register for header in collection view
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        /// register collection view
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    /// step 2 for header -  use  register and resuable for cell of UICollectionViewReusableView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        headerCell.socialApps = socialApps
        return headerCell
    }
    
    /// step 3 for header - set width and height for header in collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
    
    /// return number of cell in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    /// use register UICollectionViewCell and reusable for collection view and pass data for it
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        let appGroup = groups[indexPath.item]
        cell.appGroup = appGroup
        cell.horizontalViewController.didSelectHandler = { [weak self] feedResult in
            self?.didTapHeader?(feedResult)
        }
        return cell
    }
    /// use to set width and height of cell in collection view  --- implement of UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
    /// inset padding for collection view  insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}


///  to preview desing form SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AppsPageController_Preview : PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable  {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AppsPageController_Preview.ContainerView>) -> UIViewController {
            return AppsPageVC()
        }
        
        func updateUIViewController(_ uiViewController: AppsPageController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AppsPageController_Preview.ContainerView>) {
            
        }
    }
}
#endif
