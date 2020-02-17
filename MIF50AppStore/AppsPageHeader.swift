//
//  AppsPageHeader.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/7/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
    
    
    let appsHeaderHorizontalController = AppsHeaderHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(appsHeaderHorizontalController.view)
        appsHeaderHorizontalController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
