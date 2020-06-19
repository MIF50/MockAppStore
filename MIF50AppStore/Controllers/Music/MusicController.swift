//
//  MusicController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/13/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class MusicController: BaseListContoller {
    // cells Ids
    fileprivate let tractorCellId = "tractorCellId"
    fileprivate let musicLoadingFooterId = "musicLoadingFooterId"
    
    fileprivate var resultsApp = [ResultApp]()
    
    // pagination
    fileprivate var offsetPage = 0
    fileprivate var isPagination = false
    fileprivate var isDonePagination = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        fetchData()
    }
    
    fileprivate func initCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(TractorCell.self, forCellWithReuseIdentifier: tractorCellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: musicLoadingFooterId)
    }
    
    fileprivate func fetchData(){
        Service.share.fetchMusicData(offset: offsetPage) { (res) in
            switch res {
            case .success(let appSearch):
                self.resultsApp += appSearch.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case.failure(let error):
                print("MusicController error =  \(error)")
            }
        }
    }
    
    fileprivate func fetchDataPagniation(){
        offsetPage += 1
        isPagination = true
        Service.share.fetchMusicData(offset: offsetPage) { (res) in
            switch res {
            case .success(let appSearch):
                if appSearch.results.count == 0 {
                    self.isDonePagination = true
                }
                sleep(2)
                self.resultsApp += appSearch.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case.failure(let error):
                print("MusicController error =  \(error)")
            }
        }
        isPagination = false
        
    }
}
// MARK:- UICollectionViewDataSource
extension MusicController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsApp.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tractorCellId, for: indexPath) as! TractorCell
        cell.resultApp = resultsApp[indexPath.item]
        // init pagination
        if indexPath.item == resultsApp.count - 1 && !isPagination {
            fetchDataPagniation()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: musicLoadingFooterId, for: indexPath) as! MusicLoadingFooter
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePagination ? 0: 100
        return .init(width: view.frame.width, height: height)
    }
    
}
// MARK:- Collection View Flow Layout Delegate
extension MusicController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
}




///  to preview desing form SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MusicController_Preview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MusicController_Preview.ContainerView>) -> UIViewController {
            return MusicController()
        }
        
        func updateUIViewController(_ uiViewController: MusicController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MusicController_Preview.ContainerView>) {
            
        }
        
        
    }
}

#endif
