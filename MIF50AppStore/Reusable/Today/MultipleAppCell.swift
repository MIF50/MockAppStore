//
//  MultipleAppCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/28/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {
    
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
    let seperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
       
        
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
    
    fileprivate func arrangeLayout() {
        let stackview = UIStackView(arrangedSubviews: [
            imageView,
            VStackView(arrangedSubViews: [nameLabel,companyLabel],spacing: 4),
            btnGet
            ])
        
        stackview.spacing = 16
        stackview.alignment = .center
        
        addSubview(stackview)
        stackview.fillSuperview()
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: btnGet.trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: -8, right: 0),
                             size: .init(width: 0, height: 0.3))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MultipleAppCell_Preview: PreviewProvider {
    static var previews: some View {
        MultipleAppCellRepresentable().previewLayout(.fixed(width: 400, height: 100))
    }
}

struct MultipleAppCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return MultipleAppCell()
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

#endif
