//
//  HomeScreen.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//

import SwiftUI


struct HomeScreen: View {
    @ObservedObject var intentHandler: BookIntentHandler
    @State private var searchString: String  = ""
    
    var body: some View {
        NavigationView {
            VStack {
                    List(intentHandler.state.books) { book in
                        NavigationLink(destination: BookDetailsScreen(book: book, intentHandler: intentHandler)) {
                            BookRowView(book: book)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchString, suggestions: {
                        ForEach(intentHandler.state.searchResults, id:\.self){ suggestion in
                                SuggestionListView(suggestion: suggestion)
                            .searchCompletion(suggestion.title)
                        }
                        
                    })
                    .textInputAutocapitalization(.never)
                    .onSubmit(of: .search) {
                        Task{
                            await
                            intentHandler.handle(.searchBooks(query: searchString))
                        }
                    }
                    .onChange(of: searchString , { a, b in
                        Task{
                            await
                            intentHandler.handle(.filterBooks(query: b))
                        }
                    })
            }
            .padding()
            .applyCustomListBackground()
            .tint(Color.green)

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task{
                            await
                            intentHandler.handle(.navigateTo(screen: .favorites))
                        }
                    }) {
                        Image(systemName: "star.fill")
                    }
                }
            }
            .refreshable {
                Task{
                    await
                    intentHandler.handle(.syncBooks)
                }
            }
            .applyCustomBackground()
        }.onAppear {
            Task{
                await
                intentHandler.handle(.loadBooks)
            }
        }
    }
}



struct SuggestionListView: View {
    let suggestion: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(suggestion.title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(suggestion.author)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        let repo = ScreenPreviewRepository()
        let intentHandler = BookIntentHandler(repository: repo)
        HomeScreen(intentHandler:intentHandler)
    }
}
