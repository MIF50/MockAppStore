//
//  PreviewRowCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class PreviewRowCell: UICollectionViewCell {
    
    let previewRatingLabel = UILabel(text: "Preview & Rating", font: .boldSystemFont(ofSize: 24))
    let horizontalPrviewController = PreviewsContoller()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeLayout()
    }
    
    private func arrangeLayout() {
        addSubview(previewRatingLabel)
        previewRatingLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                                  padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        addSubview(horizontalPrviewController.view)
        horizontalPrviewController.view.anchor(top: previewRatingLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                                               padding: .init(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PreviewRowCell_Preview: PreviewProvider {
    static var previews: some View {
        PreviewRowCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct PreviewRowCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return PreviewRowCell()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#endif
