//
//  Service.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 1/31/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class APIServices {
    
    static var share = APIServices() // singleton
    private let networking = NetworkingClient.shared
    
    
    func fetchApps(searchTerm: String, complition:@escaping (Result<SearchResult,Error>) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        networking.didRequest(stringUrl: urlString, complition: complition)
    }
    

    func fetchGames(complition:@escaping (Result<AppGroup,Error>) -> ()){
        let URL_FETCH_APPS = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/50/explicit.json"
        networking.didRequest(stringUrl: URL_FETCH_APPS, complition: complition)
    }
    
    func fetchTopGrossing(complition:@escaping (Result<AppGroup,Error>) -> ()){
        let URL_FETCH_GROSSING = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        networking.didRequest(stringUrl: URL_FETCH_GROSSING, complition: complition)
    }
    
    func fetchTopFree(complition:@escaping (Result<AppGroup,Error>) -> ()){
        let URL_TOP_FREE = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json"
        networking.didRequest(stringUrl: URL_TOP_FREE, complition: complition)
    }
    
    
    // fetch social app
    func fetchSocialApp(complition: @escaping (Result<[SocialApp],Error>) -> ()){
        let URL_SOCIAL_APP = "https://api.letsbuildthatapp.com/appstore/social"
        networking.didRequest(stringUrl: URL_SOCIAL_APP, complition: complition)
    }
    
    func fetchPageDetails(id:String, complition: @escaping (Result<SearchResult,Error>) -> ()) {
        // https://itunes.apple.com/lookfor?id=971265422
        let URL_STRING = "https://itunes.apple.com/lookup?id=\(id)"
        networking.didRequest(stringUrl: URL_STRING, complition: complition)


    }
    
    func fetchPreviewsAndRating(id: String,complition: @escaping (Result<Preview,Error>) -> ()) {
        let URL_STRING = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(id)/sortby=mostrecent/json?l=en&cc=us"
        networking.didRequest(stringUrl: URL_STRING, complition: complition)
    }
    
    // https://itunes.apple.com/search?term=tralor&offset=25&limit=25
    
    func fetchMusicData(offset: Int = 0, complition: @escaping (Result<SearchResult,Error>) -> ()) {
        let URL_STRING = "https://itunes.apple.com/search?term=taylor&offset=\(offset)&limit=20"
        networking.didRequest(stringUrl: URL_STRING, complition: complition)
    }
}
