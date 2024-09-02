//
//  MockRepository.swift
//  BookAppTests
//
//  Created by Andrii Tishchenko on 2024-09-01.
//

import Foundation
@testable import BookApp

class MockRepository: Repository {
    var books: [Book] = []
    var favorites: [Int] = []
    var error: Error?
    
    func syncBooks() async throws {
        if let error = error {
            throw error
        }
        // Simulate syncing books
        books = [
            Book(id: 1, title: "Mock Book", author: "Mock Author", coverImageURL: URL(string: "https://google.com"), text: "SOme text" ),
            Book(id: 2, title: "Mock Book", author: "Mock Author", coverImageURL: URL(string: "https://google.com"), text: "SOme text" )
        ]
    }
    
    func fetchBooks() async throws -> [Book] {
        if let error = error {
            throw error
        }
        return books
    }
    
    func fetchFavorites() async throws -> [Int] {
        if let error = error {
            throw error
        }
        return favorites
    }
    
    func search(query: String, isFavorite: Bool) async throws -> [Book] {
        if let error = error {
            throw error
        }
        return books.filter { $0.title.contains(query) || $0.author.contains(query) }
    }
    
    func favoriteMark(id: Int, isFavorite: Bool) async throws {
        if let error = error {
            throw error
        }
        if isFavorite {
            favorites.append(id)
        } else {
            favorites.removeAll { $0 == id }
        }
    }
}
