//
//  VerticalStackView.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 1/27/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class VStackView: UIStackView {

    init(arrangedSubViews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        
        arrangedSubViews.forEach({addArrangedSubview($0)})
        self.axis = .vertical
        self.spacing = spacing

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
