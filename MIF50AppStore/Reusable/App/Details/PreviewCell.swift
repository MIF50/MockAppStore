//
//  PreviewCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "titile label", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "author label", font: .systemFont(ofSize: 16))
    let starLabel = UILabel(text: "star", font: .systemFont(ofSize: 16))
    let bodyLabel = UILabel(text: "body text label with very big descrition \n body text label with very big descrition \nbody text label with very big descrition ", font: .systemFont(ofSize: 18),numberOfLine: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
    }
    
    private func initView() {
        backgroundColor = #colorLiteral(red: 0.9553928684, green: 0.9553928684, blue: 0.9553928684, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func arrangeLayout() {
        let topHorizontalStack = UIStackView(arrangeViews: [titleLabel,authorLabel])
        let stackview = VerticalStackView(arrangedSubViews: [
            topHorizontalStack,
            starLabel,
            bodyLabel
        ], spacing: 12)
        
        addSubview(stackview)
        stackview.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
