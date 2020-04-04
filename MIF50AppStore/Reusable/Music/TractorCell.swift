//
//  TractorCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/13/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class TractorCell: UICollectionViewCell {
    
    var resultApp: ResultApp! {
        didSet {
            imageView.sd_setImage(with: URL(string: resultApp.artworkUrl100))
            nameLabel.text = resultApp.trackName
            descriptionLabel.text = "\(resultApp.artistName ?? "") • \(resultApp.collectionName ?? "")"
        }
    }
    
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Name Label", font: .boldSystemFont(ofSize: 18))
    let descriptionLabel = UILabel(text: "this is description", font: .systemFont(ofSize: 16),numberOfLine: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
        
    }
    
    fileprivate func initView(){
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.size(width: 80, height: 80)
        
    }
    
    fileprivate func arrangeLayout(){
        let vstack = VerticalStackView(arrangedSubViews: [nameLabel,descriptionLabel], spacing: 4)
        let hstack = UIStackView(arrangeViews: [imageView,vstack], customSpacing: 8)
        hstack.alignment = .center
        addSubview(hstack)
        hstack.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TractorCell_Preview: PreviewProvider {
    static var previews: some View {
        TractorCellRepresentable().previewLayout(.fixed(width: 400, height: 100))
    }
}

struct TractorCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return TractorCell()
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

#endif
