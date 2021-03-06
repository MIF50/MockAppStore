//
//  TodayCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/22/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    
    var topConstraint: NSLayoutConstraint!
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28))
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
    let descriptionLabel = UILabel(text: "All the tolls and app you need to intelligently organize you life the right way.", font: .systemFont(ofSize: 18),numberOfLine: 3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
        
    }
    
    private func initView(){
        backgroundColor = .white
        layer.cornerRadius = 16
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func arrangeLayout(){
        let containerImage = UIView()
                containerImage.addSubview(imageView)
                imageView.centerInSuperview(size: .init(width: 240, height: 240))
        
                let vstack = VStackView(arrangedSubViews: [
                categoryLabel,
                titleLabel,
                containerImage,
                descriptionLabel
                ], spacing: 8)
                
        vstack.backgroundColor = .red
                addSubview(vstack)
                vstack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                                 padding: .init(top: 0, left: 24, bottom: 24, right: 24))
                topConstraint = vstack.topAnchor.constraint(equalTo: topAnchor, constant: 24)
                topConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TodayCell_Preview: PreviewProvider {
    static var previews: some View {
        TodayCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct TodayCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return TodayCell()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#endif
