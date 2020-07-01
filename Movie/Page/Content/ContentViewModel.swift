//
//  ContentViewModel.swift
//  Movie
//
//  Created by user on 30/06/20.
//  Copyright © 2020 Tommy. All rights reserved.
//

import SwiftUI
import Combine


class ContentViewModel: ObservableObject {
    @Published private var model: ContentModel<CardModel, String, APIPath> = ContentViewModel.createContentModel()
    
    var cancellationToken: AnyCancellable?
    
    static func createContentModel() -> ContentModel<CardModel, String, APIPath>{
        let dataCards: Array<CardModel> = []
        let categories: Array<String> = []
        let paths: Array<APIPath> = []

        return ContentModel<CardModel, String, APIPath>(numberOfCards: dataCards.count, cardContentfactory: { (indexCard) -> CardModel in
            dataCards[indexCard]
        }, numberOfCategory: categories.count, categoryContent: { (indexOfCategories) -> String in
            categories[indexOfCategories]
        }) { (indexOfCategories) -> APIPath in
            paths[indexOfCategories]
        }
    }
    
    
    static func createContentModel(dataCards: Array<CardModel>) -> ContentModel<CardModel, String, APIPath>{
        
        let categories: Array<String> = ["Popular", "Upcoming", "Top Rated", "Now Playing"]
        let paths: Array<APIPath> = [.moviePopular, .movieUpComing, .movieTopRate, .movieNowPlaying]
        return ContentModel<CardModel, String, APIPath>(numberOfCards: dataCards.count, cardContentfactory: { (indexCard) -> CardModel in
            dataCards[indexCard]
        }, numberOfCategory: categories.count, categoryContent: { (indexOfCategories) -> String in
            categories[indexOfCategories]
        }) { (indexOfCategories) -> APIPath in
            paths[indexOfCategories]
        }
        
    }
    
    init() {
        getMovies(search: .moviePopular)
    }
    
    
    var cards: Array<ContentModel<CardModel, String, APIPath>.Card> {
        return model.cards
    }
    
    var categories: Array<ContentModel<CardModel, String, APIPath>.Category> {
        return model.categories
    }
    
    func choose(card: ContentModel<CardModel, String, APIPath>.Card) {
        model.choose(card: card)
    }
    
    func click(category: ContentModel<CardModel, String, APIPath>.Category) {
        model.click(categories: category)
    }
    
    func choose(search: APIPath, category: ContentModel<CardModel, String, APIPath>.Category) {
        model.choose(category: category)
        getMovies(search: search)
    }
    
    
    func getMovies(search category: APIPath) {
        let test: AnyPublisher<ListDataResponse,Error> =  ApiData.request(category)
        cancellationToken = test
            .mapError({ error -> Error in return error })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    let dataCards: Array<CardModel> = $0.movies
                    self.model = ContentViewModel.createContentModel(dataCards: dataCards)
            })
    }
    
}
