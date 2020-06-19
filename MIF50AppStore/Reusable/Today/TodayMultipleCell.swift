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
    
    let multipleAppVC = TodayMultipleAppsController(mode: .small)
    
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
        let stackView = VStackView(arrangedSubViews: [
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



#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TodayMultipleCell_Preview: PreviewProvider {
    static var previews: some View {
        TodayMultipleCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct TodayMultipleCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return TodayMultipleCell()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#endif
