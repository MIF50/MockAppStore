//
//  MusicVC.swift
//  MIF50AppStore
//
//  Created by MIF50 on 28/05/2021.
//  Copyright © 2021 MIF50. All rights reserved.
//

import UIKit

// MARK:- CellIDs
fileprivate let tractorCellId = "tractorCellId"
fileprivate let musicLoadingFooterId = "musicLoadingFooterId"

class MusicVC: UIViewController {
    
    // MARK:- Views    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    // MARK:- Handler
    let handler = MusicHandler()
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.fillSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchData()
        handler.callPagination = { _ in
            self.fetchDataPagniation()
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        handler.setup(collectionView)
    }
    
    fileprivate func fetchData(){
        APIServices.share.fetchMusicData(offset: handler.offsetPage) { (res) in
            switch res {
            case .success(let appSearch):
                self.handler.indexData += appSearch.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case.failure(let error):
                print("MusicController error =  \(error)")
            }
        }
    }
    
    private func fetchDataPagniation() {
        handler.enablePagination()
        APIServices.share.fetchMusicData(offset: handler.offsetPage) { (res) in
            switch res {
            case .success(let appSearch):
                if appSearch.results.count == 0 {
                    self.handler.finishPagination()
                }
                sleep(2)
                self.handler.indexData += appSearch.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case.failure(let error):
                print("MusicController error =  \(error)")
            }
        }
        handler.disablePagination()
    }
}

// MARK:- Handler
class MusicHandler: NSObject, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK:- Pagination
    private(set) var offsetPage = 0
    private var isPagination = false
    private var isDonePagination = false
    var callPagination:((IndexPath)->Void)?
    
    var indexData = [ResultApp]()
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TractorCell.self, forCellWithReuseIdentifier: tractorCellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: musicLoadingFooterId)
    }
    
    func enablePagination() {
        offsetPage += 1
        isPagination = true
    }
    
    func disablePagination() {
        isPagination = false
    }
    
    func finishPagination() {
        isDonePagination = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tractorCellId, for: indexPath) as! TractorCell
        cell.resultApp = indexData[indexPath.item]
        /// init pagination
        if indexPath.item == indexData.count - 1 && !isPagination && !isDonePagination {
            callPagination?(indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: musicLoadingFooterId, for: indexPath) as! MusicLoadingFooter
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePagination ? 0 : 100
        return .init(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 100)
    }
}

// MARK:- Preview Design
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MusicVC_Preview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MusicVC_Preview.ContainerView>) -> UIViewController {
            return MusicVC()
        }
        
        func updateUIViewController(_ uiViewController: MusicVC_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MusicVC_Preview.ContainerView>) {
            
        }
    }
}
#endif
