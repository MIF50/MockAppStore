//
//  TodayMultipleCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/28/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class TodayMultipleCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text  = todayItem.title
            multipleAppVC.feedResults = todayItem.feedResults
            multipleAppVC.collectionView.reloadData()
        }
    }
    
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32),numberOfLine: 2)
    
    let multipleAppVC = TodayMultipleAppsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
    }
    
    private func  initView() {
        backgroundColor = .white
        layer.cornerRadius = 16
    }
    
    private func arrangeLayout() {
        let stackView = VerticalStackView(arrangedSubViews: [
            categoryLabel,
            titleLabel,
            multipleAppVC.view
        ], spacing: 8)
        addSubview(stackView)
        
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
