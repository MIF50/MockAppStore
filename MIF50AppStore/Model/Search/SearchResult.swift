//
//  SearchResult.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 1/31/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import Foundation

struct SearchResult : Decodable {
    let resultCount: Int
    let results: [ResultApp]
}

struct ResultApp: Decodable {
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String  // icon image
    let formattedPrice: String
    let description: String
    let releaseNotes: String
}
