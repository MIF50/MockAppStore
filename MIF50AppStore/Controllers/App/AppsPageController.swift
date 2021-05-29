//
//  AppsController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/3/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsPageController: BaseListContoller, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cell"
    fileprivate let headerId = "headerId"
    
    fileprivate var groups = [AppGroup]()
    fileprivate var socialApps = [SocialApp]()
    
    // create load indicator
    let activityIndicatorView : UIActivityIndicatorView = {
        let avi = UIActivityIndicatorView(style: .large)
        avi.color = .black
        avi.startAnimating()
        avi.hidesWhenStopped = true
        return avi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        //
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        /// register collection view
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        /// step 1 for header - register for header in collection view
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchApps()
    }
    
    fileprivate func fetchApps(){
        // help you sync your data feches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        APIServices.share.fetchGames { response in
            dispatchGroup.leave()
            switch response {
            case .success(let appGoup):
                self.groups.append(appGoup)
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        APIServices.share.fetchTopGrossing { response in
            dispatchGroup.leave()
            switch response {
            case .success(let appGroup):
                self.groups.append(appGroup)
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        APIServices.share.fetchTopFree { response in
            dispatchGroup.leave()
            switch response {
            case .success(let appGroup):
                self.groups.append(appGroup)
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        APIServices.share.fetchSocialApp { response in
            dispatchGroup.leave()
            switch response {
            case .success(let socialApps):
                self.socialApps = socialApps
            case .failure(let error):
                print(error)
            }
        }
        
        
        // completion
        dispatchGroup.notify(queue: .main){
            self.activityIndicatorView.stopAnimating()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    
    /// step 2 for header -  use  register and resuable for cell of UICollectionViewReusableView
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        headerCell.appsHeaderHorizontalController.socialApps = self.socialApps
        headerCell.appsHeaderHorizontalController.collectionView.reloadData()
        
        return headerCell
    }
    
    /// step 3 for header - set width and height for header in collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 300)
    }
    
    /// return number of cell in collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    /// use register UICollectionViewCell and reusable for collection view and pass data for it
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalViewController.appGroup = appGroup
        cell.horizontalViewController.collectionView.reloadData()
        cell.horizontalViewController.didSelectHandler = { [weak self] feedResult in
            let controller = AppDetailsController(appId: feedResult.id)
            controller.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
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
            return AppsPageController()
        }
        
        func updateUIViewController(_ uiViewController: AppsPageController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AppsPageController_Preview.ContainerView>) {
            
        }
    }
}


#endif
