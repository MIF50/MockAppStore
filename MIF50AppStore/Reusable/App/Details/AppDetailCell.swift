//
//  AppDetailCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    
    var appResult: ResultApp! {
        didSet {
            print("image Url \(appResult?.artworkUrl100 ?? "image nil")")
            appIconImage.sd_setImage(with: URL(string : appResult?.artworkUrl100 ?? ""))

            appName.text = appResult.trackName
            btnPrice.setTitle(appResult.formattedPrice, for: .normal)
            releaseLabel.text = appResult.releaseNotes

        }
    }
    
    let appIconImage = UIImageView(cornerRadius: 16)
    let appName = UILabel(text: "", font: .boldSystemFont(ofSize: 24),numberOfLine: 2)
    let btnPrice = UIButton(title: "")
    let whatNewLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 22))
    let releaseLabel = UILabel(text: "", font: .systemFont(ofSize: 18), numberOfLine: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
    }
    
    
    private func initView(){
        // app icon image
        appIconImage.constrainWidth(constant: 140)
        appIconImage.constrainHeight(constant: 140)
        
        // btn price
        btnPrice.backgroundColor = #colorLiteral(red: 0, green: 0.4823431862, blue: 1, alpha: 1)
        btnPrice.constrainHeight(constant: 32)
        btnPrice.constrainWidth(constant: 90)
        btnPrice.layer.cornerRadius = 32 / 2
        btnPrice.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btnPrice.setTitleColor(.white, for: .normal)
    }
    
    private func arrangeLayout(){
        let leftTopVerticalStack = VerticalStackView(arrangedSubViews: [
            appName,
            UIStackView(arrangedSubviews: [btnPrice,UIView()]),
            UIView()
        ], spacing: 12)
        
        let topHorizontalStack = UIStackView(arrangeViews: [appIconImage,leftTopVerticalStack], customSpacing: 12)
        
        let verticalStack = VerticalStackView(arrangedSubViews: [
            topHorizontalStack,
            whatNewLabel,
            releaseLabel
        ], spacing: 16)
        
        addSubview(verticalStack)
        verticalStack.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
