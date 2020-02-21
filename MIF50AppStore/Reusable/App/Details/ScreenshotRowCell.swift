//
//  PreviewCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class ScreenshotRowCell: UICollectionViewCell {
    
    let previewLabel = UILabel(text: "Preview", font: .boldSystemFont(ofSize: 24))
    let horizontalPreviewScreenshotController = previewScreenshotController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        arrangeLayout()
        
    }
    
    private func arrangeLayout() {
        addSubview(previewLabel)
        previewLabel.anchor(
                   top: topAnchor,
                   leading: leadingAnchor,
                   bottom: nil,
                   trailing: trailingAnchor,
                   padding: .init(top: 0, left: 20, bottom: 0, right: 20)
               )
        
        addSubview(horizontalPreviewScreenshotController.view)
        horizontalPreviewScreenshotController.view.anchor(
            top: previewLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
