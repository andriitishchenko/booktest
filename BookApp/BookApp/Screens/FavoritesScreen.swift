//
//  FavoritesScreen.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//

import SwiftUI

struct FavoritesScreen: View {
    @ObservedObject var intentHandler: BookIntentHandler
    @State private var showConfirmationDialog = false
    @State private var bookToRemove: Book?

    var body: some View {
        NavigationView {
            VStack {
                if intentHandler.state.favorites.isEmpty {
                        Text("No favorites yet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                } else {
                    List {
                        Section {
                            ForEach(intentHandler.state.books.filter { intentHandler.state.favorites.contains($0.id) }) { book in
                                NavigationLink(destination: BookDetailsScreen(book: book, intentHandler: intentHandler)) {
                                    BookRowView(book: book)
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first {
                                    let bookToBeRemoved = intentHandler.state.books.filter { intentHandler.state.favorites.contains($0.id) }[index]
                                    bookToRemove = bookToBeRemoved
                                    showConfirmationDialog = true
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .padding()
            .applyCustomListBackground()
            .navigationTitle("Favorites")
            .toolbar {
                // Home Button in the Toolbar
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigateToHome()
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            .alert(isPresented: $showConfirmationDialog) {
                Alert(
                    title: Text("Remove from Favorites"),
                    message: Text("Are you sure you want to remove this book from your favorites?"),
                    primaryButton: .destructive(Text("Remove")) {
                        if let book = bookToRemove {
                            Task{
                                await intentHandler.handle(.favoriteMark(id: book.id, isFavorite: false))
                        }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .applyCustomBackground()
        }
        .onAppear(){
            Task{
                await
                intentHandler.handle(.loadFavorite)
            }
        }
    }
    // Navigate to HomeScreen
    private func navigateToHome() {
        Task{
            await
            intentHandler.handle(.navigateTo(screen: .home))
        }
    }
}

struct FavoritesScreen_Previews: PreviewProvider {
    static var previews: some View {
        let repo = ScreenPreviewRepository()
        let intentHandler = BookIntentHandler(repository: repo)
                
        FavoritesScreen(intentHandler: intentHandler)
    }
}
