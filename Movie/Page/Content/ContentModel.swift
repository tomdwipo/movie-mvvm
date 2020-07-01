//
//  ContentModel.swift
//  Movie
//
//  Created by user on 30/06/20.
//  Copyright © 2020 Tommy. All rights reserved.
//

import Foundation

struct ContentModel<CardContent, Categories, SearchPath> {
    var cards: Array<Card>
    var categories: Array<Category>
    
    mutating func choose(card: Card){
        let choosenIndex: Int = self.index(of: card)
        self.cards[choosenIndex].isChangeCard = !self.cards[choosenIndex].isChangeCard
    }
    
    mutating func click(categories: Category){
        let choosenIndex: Int = 0
        self.categories[choosenIndex].isShownCategories = !self.categories[choosenIndex].isShownCategories
    }
    
    func choose(category: Category) {
        print("Category choosen: \(category)")
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return 0
    }
    
    init(numberOfCards: Int, cardContentfactory: (Int) -> CardContent, numberOfCategory: Int, categoryContent: (Int) -> Categories, searchPathContent: (Int) -> SearchPath) {
        cards = Array<Card>()
        categories = Array<Category>()
        
        for indexOfCard in 0..<numberOfCards {
            let content: CardContent = cardContentfactory(indexOfCard)
            cards.append(Card(content: content, id: indexOfCard*2))
        }
        
        for indexOfCategory in 0..<numberOfCategory {
            let category: Categories = categoryContent(indexOfCategory)
            let searchPath: SearchPath = searchPathContent(indexOfCategory)
            categories.append(Category(id: indexOfCategory*2, categories: category, searchPath: searchPath))
        }
        
    }
  
    struct Card: Identifiable {
        var content: CardContent
        var id: Int
        var isChangeCard: Bool = false
    }
    
    struct Category: Identifiable {
        var id: Int
        var categories: Categories
        var searchPath: SearchPath
        var isShownCategories: Bool = false
    }
    
}

struct CategoryChoosen {
    var categories: String
    var searchPath: APIPath
}
