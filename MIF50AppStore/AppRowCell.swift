//
//  AppRowCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/7/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppRowCell: UICollectionViewCell {
    
    var feedResult: FeedResult! {
        didSet {
            nameLabel.text = feedResult.name
            companyLabel.text = feedResult.artistName
            imageView.sd_setImage(with: URL(string: feedResult.artworkUrl100))
        }
    }
    
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App name", font: UIFont.systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "campany name", font: UIFont.systemFont(ofSize: 13))
    let btnGet = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
       
        let stackview = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubViews: [nameLabel,companyLabel],spacing: 4),
            btnGet
            ])
        
        stackview.spacing = 16
        stackview.alignment = .center
        
        addSubview(stackview)
        stackview.fillSuperview()
    }
    
    fileprivate func initView() {
        // image view
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        imageView.backgroundColor = .purple
        
        // button get
        btnGet.backgroundColor = UIColor(white: 0.95, alpha: 1)
        btnGet.constrainWidth(constant: 82)
        btnGet.constrainHeight(constant: 32)
        btnGet.layer.cornerRadius = 32 / 2
        btnGet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
