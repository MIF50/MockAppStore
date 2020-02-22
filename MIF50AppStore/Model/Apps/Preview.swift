//
//  Preview.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import Foundation

struct Preview: Decodable {
    let feed: FeedPreview
}

struct FeedPreview: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let author: Author
    let title: Label
    let content: Label
    let rating: Label
    
    private enum CodingKeys: String, CodingKey {
        case author , title, content
        case rating = "im:rating"
    }
}


struct Author: Decodable {
    let uri: Label
    let name: Label
}

struct Label: Decodable {
    let label: String
}
