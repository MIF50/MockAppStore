//
//  AppsGroupCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/3/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit


class AppsGroupCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "App Section", font: UIFont.boldSystemFont(ofSize: 30))
    
    /// create horizontal view controller in side cell for nested collection view
    let horizontalViewController = AppsHorizontalController()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
        
        addSubview(horizontalViewController.view)
        horizontalViewController.view.backgroundColor = .blue
        horizontalViewController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AppsGroupCell_Preview: PreviewProvider {
    static var previews: some View {
        AppsGroupCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct AppsGroupCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return AppsGroupCell()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#endif
