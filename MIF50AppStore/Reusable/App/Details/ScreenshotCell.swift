//
//  ScreenshotCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    
    var screenshotUrl: String! {
        didSet {
            imagePreview.sd_setImage(with: URL(string: screenshotUrl ?? ""))
        }
    }
    
    let imagePreview = UIImageView(cornerRadius: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imagePreview)
        imagePreview.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
