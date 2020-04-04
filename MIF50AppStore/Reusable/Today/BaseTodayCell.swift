//
//  BaseTodayCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/28/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    var todayItem: TodayItem!
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.transform =  self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createShadowToCell()
    }
    private func createShadowToCell(){
        self.backgroundView = UIView()
        addSubview(self.backgroundView!)
        guard let backgroundView = self.backgroundView  else { return }
        backgroundView.fillSuperview()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 16

        backgroundView.layer.shadowOpacity = 0.1
        backgroundView.layer.shadowRadius = 10
        backgroundView.layer.shadowOffset = .init(width: 0, height: 10)
        backgroundView.layer.shouldRasterize = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct BaseTodayCell_Preview: PreviewProvider {
    static var previews: some View {
        BaseTodayCellRepresentable().previewLayout(.fixed(width: 400, height: 500))
    }
}

struct BaseTodayCellRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return BaseTodayCell()
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

#endif
