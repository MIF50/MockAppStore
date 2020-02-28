//
//  TodayItem.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/25/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit


struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    let cellType: CellType
    let feedResults: [FeedResult]
    
    
    public enum CellType: String {
       case single, muliple
    }
}
