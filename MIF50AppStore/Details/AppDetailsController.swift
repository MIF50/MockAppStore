//
//  AppDetailsController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/15/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppDetailsController : BaseListContoller {
    
    var appId :String! {
        didSet {
            Service.share.fetchPageDetails(id: appId) {  res in
                switch res {
                case .success(let searchResult):
                    print(searchResult.results.first?.description ?? "")
                case .failure(let error ):
                    print("error \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
    }
}
