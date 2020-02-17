//
//  SearchAppController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 1/24/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit


class SearchAppController: BaseListContoller, UICollectionViewDelegateFlowLayout ,UISearchBarDelegate {
    
    fileprivate let cellId = "Cell"
    
    /// app results
    var appResults = [ResultApp]()
    
    /// search bar for search
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    /// label for start screen and no data in collection view
    fileprivate let enterSearchTermLabel: UILabel = {
       let label = UILabel()
        label.text = "please enter search term above .... "
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    /// timer for delay search speed when typing...
    var timer: Timer?
       
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        /// register collection view with SearchResultCell
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        /// init label and set constains ..
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        
        setupSearchBar()
    }
    /// setup search bar properity ...
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        /// for ios 13
//        searchController.showsSearchResultsController = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.becomeFirstResponder()
        searchController.searchBar.delegate = self
    }
   
    /// delegate listener for chaning in search bar ...
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /// introduce some delay before perfoming the search
        /// throtting the search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            /// this will actually fire my search
            self.fetchItunesApps(searchTerm: searchText)
        })
        
    }
    
    /// fetch itunes apps form internet
    fileprivate func fetchItunesApps(searchTerm: String){
        Service.share.fetchApps(searchTerm: searchTerm) { (response) in
            switch response {
            case .success(let searchResult):
                self.appResults = searchResult.results
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
    
    
    
    /// return number of cell in collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    /// use register UICollectionViewCell and reusable for collection view and pass data for it
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.result = appResults[indexPath.item]
        return cell
    }
    /// use to set width and height of cell in collection view  --- implement of UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 320)
    }
    
    
    
}
