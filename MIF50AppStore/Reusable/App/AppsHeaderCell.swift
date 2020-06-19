//
//  AppsHeaderCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/7/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    var socialApp : SocialApp! {
        didSet {
            companyLabel.text = socialApp.name
            titleLabel.text = socialApp.tagline
            imageview.sd_setImage(with: URL(string: socialApp.imageUrl))
        }
    }
    
    let companyLabel = UILabel(text: "facebook", font: UIFont.boldSystemFont(ofSize: 13))
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever ", font: UIFont.boldSystemFont(ofSize: 23))
    let imageview = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        arrangeLayout()
        
        
    }
    
    private func initView() {
        imageview.image = #imageLiteral(resourceName: "holiday")
        // company label
        companyLabel.textColor = .blue
        // title label
        titleLabel.numberOfLines = 2
                
    }
    
    private func arrangeLayout(){
        let stackview = VStackView(arrangedSubViews: [companyLabel, titleLabel, imageview], spacing: 10)
        
        addSubview(stackview)
        stackview.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AppsHeaderCell_Preview: PreviewProvider {
    static var previews: some View {
        AppsHeaderCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct AppsHeaderCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return AppsHeaderCell()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

#endif
