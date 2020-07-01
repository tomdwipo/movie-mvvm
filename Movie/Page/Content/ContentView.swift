//
//  ContentView.swift
//  Movie
//
//  Created by user on 29/06/20.
//  Copyright © 2020 Tommy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State var showingDetail = false

    var body: some View {
        NavigationView {
            VStack {
                ListView(viewModel: viewModel)
                if self.viewModel.categories.count != 0 && self.viewModel.categories[indexOfButton].isShownCategories {
                    CategoryView(viewModel: viewModel)
                }
                
                Button(action: {
                    withAnimation {
                        self.viewModel.click(category: self.viewModel.categories[self.indexOfButton])
                    }
                }) {
                    Text("Category").font(Font.body)
                }
                
            }
            .navigationBarTitle("Movie DB")
            .navigationBarItems(trailing: addButton)
        }
    }
    
    private var addButton: some View {
        
        Button(action: {
            self.showingDetail = true
        }) {
            Image(systemName: "heart.fill").foregroundColor(.red)
        }.sheet(isPresented: $showingDetail) {
            CardView(card: self.viewModel.cards[0], viewModel: self.viewModel)
        }
    }
    
    
    let indexOfButton: Int = 0
}

struct ListView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                ForEach(viewModel.cards) { card in
                    ZStack {
                        NavigationLink(destination: CardView(card: card, isShowFav: true, viewModel: self.viewModel)) {
                            CardView(card: card, viewModel: self.viewModel)
                        }
                        CardView(card: card, viewModel: self.viewModel)
                    }
                    
                    
                }
            }
            .frame(width: widthStack)
        }
        
    }
    
    let widthStack: CGFloat = UIScreen.main.bounds.width*2/2.1
    
}


struct CategoryView: View {
    @ObservedObject var viewModel: ContentViewModel
    var body: some View {
        VStack {
            ForEach(viewModel.categories) { category in
                Text(category.categories).padding().onTapGesture {
                    withAnimation(.easeInOut) {
                        self.viewModel.choose(search: category.searchPath, category: category)
                    }
                }
            }
            
        }.padding()
    }
}

struct CardView: View {
    var card: ContentModel<CardModel, String, APIPath>.Card
    var isShowFav: Bool = false
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        self.cardBody()
    }
    
    func cardBody() -> some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                leftContent()
                rightContent()
            }
            .foregroundColor(Color.black)
            .padding()
            
            
            RoundedRectangle(cornerRadius: cornerRadius).stroke()
            
        }
        .foregroundColor(.gray)
    }
    
    let cornerRadius: CGFloat = 4.0
    
    func leftContent() -> some View {
        AsyncImage(
            url: URL(string: String(ApiData.baseUrlImage + card.content.poster_path))!,
            placeholder:  Text("Loading...")
        )
    }
    
    func rightContent() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(card.content.title).font(.headline)
                Text(card.content.release_date).font(.caption)
                Text(card.content.overview).font(.body)
            }
            
            if self.isShowFav {
                Button(action: {
                    self.viewModel.choose(card: self.card)
                }) {
                    if !card.isChangeCard {
                        Image(systemName: "heart").foregroundColor(.red)
                    }else{
                        Image(systemName: "heart.fill").foregroundColor(.red)
                    }
                    
                }
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
