//
//  AppFullscreenHeaderCell.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/25/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        arrangeLayout()
    }
    
    private func arrangeLayout(){
        addSubview(todayCell)
        todayCell.fillSuperview()
//        addSubview(closeBtn)
//        closeBtn.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 44, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 38))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
