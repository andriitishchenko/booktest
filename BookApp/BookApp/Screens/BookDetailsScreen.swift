//
//  BookDetailsScreen.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//

import SwiftUI

struct BookDetailsScreen: View {
    let book: Book
    @ObservedObject var intentHandler: BookIntentHandler

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Cover Image
            AsyncImage(url: book.coverImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(height: 250)
                    .cornerRadius(8)
            }
            .cornerRadius(8)
            
            // Title and Author
            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(
                        Color.rowTitleColor
                    )
                
                Text(book.author)
                    .font(.title2)
                    .foregroundColor(Color.rowTitleColor.opacity(0.7))
            }
            .padding([.horizontal, .top])
            
            // Description
            Text(book.text ?? "No description available.")
                .foregroundColor(
                    Color.rowTitleColor.opacity(0.8)
                )
                .padding([.horizontal, .bottom])
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.5))
                .padding()
        )
        .navigationBarTitleDisplayMode(.inline)        
        .toolbar {
            // Favorite Button in the Toolbar
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let isFavorite = intentHandler.state.favorites.contains(book.id)
                    Task{
                        await intentHandler.handle(.favoriteMark(id: book.id, isFavorite: !isFavorite))
                    }
                }) {
                    Image(systemName: intentHandler.state.favorites.contains(book.id) ? "heart.fill" : "heart")
                        .foregroundColor(intentHandler.state.favorites.contains(book.id) ? .red : .white)
                }
            }
        }
        .applyCustomBackground()
    }
}



struct BookDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        let repo = ScreenPreviewRepository()
        let intentHandler = BookIntentHandler(repository: repo)
        NavigationStack {
            BookDetailsScreen(book: repo.books[1], intentHandler: intentHandler)
        }
    }
}

