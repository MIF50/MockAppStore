//
//  SearchAppVC.swift
//  MIF50AppStore
//
//  Created by MIF50 on 28/05/2021.
//  Copyright © 2021 MIF50. All rights reserved.
//

import UIKit

class SearchAppVC: UIViewController {
    
    // MARK:- Views
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let searchConttoller = UISearchController(searchResultsController: nil)
    
    private let enterSearchTermLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "please enter search term above .... "
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }()
    
    // MARK:- Hander
    private let hander = SearchAppHandler()
    
    var timer: Timer?
    
    override func loadView() {
        super.loadView()
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(
            padding: .init(top: 100, left: 50, bottom: 0, right: 50)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureHandler()
    }
    
    private func configureSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchConttoller
        navigationItem.hidesSearchBarWhenScrolling = true
        /// for ios 13
        // searchController.showsSearchResultsController = true
        searchConttoller.obscuresBackgroundDuringPresentation = false
        searchConttoller.becomeFirstResponder()
        searchConttoller.searchBar.delegate = self
    }
    
    private func configureHandler() {
        hander.setup(collectionView)
        hander.hideSearchTermLabel = { count in
            self.enterSearchTermLabel.isHidden = count != 0
        }
        //Actions
        hander.didTapSearchCell = { trackId in
            let appId = String(trackId)
            let appDetailVC = AppDetailsController(appId: appId)
            self.navigationController?.pushViewController(appDetailVC, animated: true)
        }
    }
    
    /// fetch itunes apps form internet
    fileprivate func fetchItunesApps(searchTerm: String){
        APIServices.share.fetchApps(searchTerm: searchTerm) { (response) in
            switch response {
            case .success(let searchResult):
                self.hander.indexData = searchResult.results
                /// to update data of collection view in main thread .
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                // we handle error here
                print("error fetch apps \(error)")
            }
        }
        
    }
}

// MARK:- SearchBar
extension SearchAppVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false,block: { _ in
            self.fetchItunesApps(searchTerm: searchText)
        })
    }
}

// MARK:- SearchAppHandler
class SearchAppHandler: NSObject,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    // MARK:- CellIds
    fileprivate let cellId = "Cell"
    
    var indexData = [ResultApp]()
    var hideSearchTermLabel:((Int)->Void)?
    var didTapSearchCell:((Int)->Void)?
    
    func setup(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hideSearchTermLabel?(indexData.count)
        return indexData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.result = indexData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapSearchCell?(indexData[indexPath.item].trackId)
    }
}

// MARK:- Preview Design
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SearchVC_Preview : PreviewProvider {
    
    static var previews: some View {
         ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable  {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SearchVC_Preview.ContainerView>) -> UIViewController {
            return SearchAppVC()
        }
        
        func updateUIViewController(_ uiViewController: SearchVC_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SearchVC_Preview.ContainerView>) {
            
        }
    }
}
#endif
