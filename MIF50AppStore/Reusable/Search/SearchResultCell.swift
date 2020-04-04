//
//  SearchResultCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 1/25/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultCell: UICollectionViewCell {
    
    var result: ResultApp! {
        didSet {
            nameLabel.text = result.trackName
            categoryLabel.text = result.primaryGenreName
            ratingLabel.text = "Rating: \(result.averageUserRating ?? 0)"
            // load images
            appIconImageView.sd_setImage(with: URL(string: result.artworkUrl100))
            screenShot1ImageView.sd_setImage(with: URL(string: result.screenshotUrls![0]))
            if result.screenshotUrls!.count > 2 {
                screenShot2ImageView.sd_setImage(with: URL(string: result.screenshotUrls![1]))
            }
            if result.screenshotUrls!.count > 3 {
                screenShot3ImageView.sd_setImage(with: URL(string: result.screenshotUrls![2]))
            }
        }
    }
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.constrainWidth(constant: 64)
        iv.constrainHeight(constant: 64)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel =  {
       let label = UILabel()
        label.text = "App Name"
        return label
    }()
    
    let categoryLabel: UILabel = {
       let label = UILabel()
        label.text = "Cateogry Name"
        
        return label
    }()
    
    let ratingLabel : UILabel = {
        let label = UILabel()
        label.text = "40.0 m"
        
        return label
    }()
    
    let btnGet: UIButton = {
        let btn  = UIButton(type: .system)
        btn.setTitle("Get", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        btn.constrainWidth(constant: 80)
        btn.constrainHeight(constant: 32)
        
        btn.layer.cornerRadius = 12
       return btn
    }()
    
    lazy var screenShot1ImageView = createScreenShotImageView()
    lazy var screenShot2ImageView = createScreenShotImageView()
    lazy var screenShot3ImageView = createScreenShotImageView()
    
    func createScreenShotImageView()-> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let labelStack = VerticalStackView(arrangedSubViews: [nameLabel,categoryLabel,ratingLabel])
        
        let infoTopStackView = UIStackView(arrangedSubviews: [appIconImageView,labelStack,btnGet])
        infoTopStackView.alignment = .center
        infoTopStackView.spacing = 12
        
        let screenShotStackView = UIStackView(arrangedSubviews: [screenShot1ImageView,screenShot2ImageView,screenShot3ImageView])
        screenShotStackView.axis = .horizontal
        screenShotStackView.distribution = .fillEqually
        screenShotStackView.spacing = 16
        
        let overallStackView = VerticalStackView(arrangedSubViews: [infoTopStackView,screenShotStackView],spacing: 16)
        
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SearchResultCell_Preview: PreviewProvider {
    static var previews: some View {
        SearchResultCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct SearchResultCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return SearchResultCell()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#endif
