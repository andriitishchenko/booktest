//
//  BookState.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//

import Foundation

struct BookState {
    var books: [Book]
    var favorites: [Int]
    var searchResults: [Book]
    let isLoading: Bool
    let error: String?
    var routing: RoutingState
    
    static var initial: BookState {
        return BookState(books: [], favorites: [], searchResults: [], isLoading: false, error: nil, routing: .home)
    }
}

extension BookState {
    func copy(
        books: [Book]? = nil,
        favorites: [Int]? = nil,
        searchResults: [Book]? = nil,
        isLoading: Bool? = nil,
        error: String? = nil,
        routing: RoutingState? = nil
    ) -> BookState {
        return BookState(
            books: books ?? self.books,
            favorites: favorites ?? self.favorites,
            searchResults: searchResults ?? self.searchResults,
            isLoading: isLoading ?? self.isLoading,
            error: error ?? self.error,
            routing: routing ?? self.routing
        )
    }
}
