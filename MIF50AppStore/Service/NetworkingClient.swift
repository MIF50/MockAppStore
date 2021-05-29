//
//  NetworkingClient.swift
//  MIF50AppStore
//
//  Created by MIF50 on 28/05/2021.
//  Copyright © 2021 MIF50. All rights reserved.
//

import Foundation

class NetworkingClient {
    
    static let shared = NetworkingClient()
    
    private init() {}
    
    
    // generic is to declare the type later on ...
    func didRequest<T: Decodable>(stringUrl: String, complition: @escaping (Result<T,Error>)->()){
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url){ data, resp, err in
            // failure case
            if let err = err {
                complition(.failure(err))
            }
            // success case
            guard let data = data else { return }
            do {
                let resultData = try JSONDecoder().decode(T.self, from: data)
                complition(.success(resultData))
            } catch let errorJson {
                complition(.failure(errorJson))
            }
            
        }.resume()  // fires off the request ....
        
    }
    
}
