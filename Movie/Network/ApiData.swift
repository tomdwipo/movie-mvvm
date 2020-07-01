//
//  ApiData.swift
//  Movie
//
//  Created by user on 01/07/20.
//  Copyright © 2020 Tommy. All rights reserved.
//

import Foundation
import Combine

struct ApiData {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://api.themoviedb.org/3/")!
    static let apiKey = "376fb33d50fc8fed9873b625b2dc82a9"
    static let baseUrlImage = "https://image.tmdb.org/t/p/w200"
}


enum APIPath: String {
    case moviePopular = "movie/popular"
    case movieTopRate = "movie/top_rated"
    case movieUpComing = "movie/upcoming"
    case movieNowPlaying = "movie/now_playing"
}

extension ApiData {
    
    static func request<Model: Decodable>(_ path: APIPath) -> AnyPublisher<Model, Error> {
        
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        let request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher() 
    }
}
