//
//  TractorLoadingFooter.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/13/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {
    
    let aiv: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        return aiv
    }()
    
    let label: UILabel = {
        let label = UILabel(text: "loading more ... ", font: .systemFont(ofSize: 16))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeLayout()
    }
    
    fileprivate func arrangeLayout(){
        let verticalSV = VerticalStackView(arrangedSubViews: [aiv,label], spacing: 4)
        verticalSV.alignment = .center
        addSubview(verticalSV)
        verticalSV.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MusicLoadingFooter_Preview: PreviewProvider {
    static var previews: some View {
        MusicLoadingFooterRepresentable().previewLayout(.fixed(width: 400, height: 100))
    }
}

struct MusicLoadingFooterRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return MusicLoadingFooter()
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

#endif
