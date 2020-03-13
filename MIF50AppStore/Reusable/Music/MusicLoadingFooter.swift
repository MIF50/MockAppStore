//
//  TractorLoadingFooter.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/13/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {
    
    let aiv: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        return aiv
    }()
    
    let label: UILabel = {
        let label = UILabel(text: "loading more ... ", font: .systemFont(ofSize: 16))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeLayout()
    }
    
    fileprivate func arrangeLayout(){
        let verticalSV = VerticalStackView(arrangedSubViews: [aiv,label], spacing: 4)
        verticalSV.alignment = .center
        addSubview(verticalSV)
        verticalSV.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
