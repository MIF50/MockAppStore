//
//  AppsPageHeader.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/7/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
    
    
    let appsHeaderHorizontalController = AppsHeaderHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(appsHeaderHorizontalController.view)
        appsHeaderHorizontalController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct AppsPageHeader_Preview: PreviewProvider {
    static var previews: some View {
        AppsPageHeaderRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct AppsPageHeaderRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return AppsPageHeader()
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

#endif
