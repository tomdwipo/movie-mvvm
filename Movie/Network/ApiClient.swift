//
//  ApiClient.swift
//  Movie
//
//  Created by user on 01/07/20.
//  Copyright © 2020 Tommy. All rights reserved.
//

import Foundation
import Combine

struct APIClient {

    struct Response<Model> {
        let value: Model
        let response: URLResponse
    }
    
    func run<Model: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<Model>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<Model> in
                let value = try JSONDecoder().decode(Model.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher() 
    }
}
