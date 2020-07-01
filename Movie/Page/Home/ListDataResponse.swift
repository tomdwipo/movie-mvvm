//
//  ListDataResponse.swift
//  Movie
//
//  Created by user on 01/07/20.
//  Copyright © 2020 Tommy. All rights reserved.
//

import Foundation

struct ListDataResponse: Codable {
    let movies: [CardModel]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct CardModel: Codable,Identifiable {
    var id = UUID()
    var movieId: Int
    var title: String
    var release_date: String
    var overview: String
    var poster_path: String
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case title
        case release_date
        case overview
        case poster_path
    }
}
