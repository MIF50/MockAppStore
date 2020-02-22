//
//  PreviewCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    
    var entry: Entry! {
        didSet {
            titleLabel.text = entry.title.label
            authorLabel.text = entry.author.name.label
            bodyLabel.text = entry.content.label
            
            for (index, view ) in starStackView.arrangedSubviews.enumerated() {
                if let ratingInt = Int(entry.rating.label) {
                    view.alpha = index >= ratingInt ? 0 : 1
                }
            }
        }
    }
    
    let titleLabel = UILabel(text: "titile label", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "author label", font: .systemFont(ofSize: 16))
    let starStackView : UIStackView = {
        var arrangeViews = [UIView]()
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.constrainWidth(constant: 16)
            imageView.constrainHeight(constant: 16)
            arrangeViews.append(imageView)
        }
        arrangeViews.append(UIView())
        let stack = UIStackView(arrangeViews: arrangeViews)
        
        return stack
    }()
    let bodyLabel = UILabel(text: "body text label with very big descrition \n body text label with very big descrition \nbody text label with very big descrition ", font: .systemFont(ofSize: 18),numberOfLine: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
    }
    
    private func initView() {
        backgroundColor = #colorLiteral(red: 0.9553928684, green: 0.9553928684, blue: 0.9553928684, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        authorLabel.textColor = #colorLiteral(red: 0.6725491751, green: 0.6725491751, blue: 0.6725491751, alpha: 1)
        
    }
    
    private func arrangeLayout() {
        let topHorizontalStack = UIStackView(arrangeViews: [titleLabel,authorLabel],customSpacing: 8)
     
        let stackview = VerticalStackView(arrangedSubViews: [
            topHorizontalStack,
            starStackView,
            bodyLabel
        ], spacing: 12)
        
        addSubview(stackview)
        stackview.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 20, left: 20, bottom: 0, right: 20))
//        stackview.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
