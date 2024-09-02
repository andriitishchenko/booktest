//
//  BookRepository.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-30.
//

import Foundation

extension Book: BookConvertible{
    func toBook() -> Book {
        return self
    }
}

protocol Repository {
    func syncBooks() async throws
    func fetchBooks() async throws -> [Book]
    func fetchFavorites() async throws -> [Int]
    func search(query: String, isFavorite: Bool) async throws -> [Book]
    func favoriteMark(id: Int, isFavorite: Bool) async throws
}

class BookRepository: Repository {
    private let localSource: LocalStorageSourceProtocol
    private let remoteSource: RemoteSourceProtocol
    
    init(localSource: LocalStorageSourceProtocol, remoteSource: RemoteSourceProtocol) {
        self.localSource = localSource
        self.remoteSource = remoteSource
    }
    
    // Sync books with remote source and save to local source
    func syncBooks() async throws {
        do {
            let apiBooks = try await remoteSource.fetchBooks()
            
            // Convert APIBooks to Books
            let books = apiBooks.map { $0.toBook() }
            
            // Sync books with Core Data
            try await localSource.syncBooks(books: books)
        } catch {
            // Handle error
            print("Failed to sync books: \(error)")
            throw error
        }
    }
    
    // Fetch books from local source
    func fetchBooks() async throws -> [Book] {
        return try await localSource.fetchBooks()
    }
    
    // Fetch favorites from local source
    func fetchFavorites() async throws -> [Int] {
        return try await localSource.fetchFavorites()
    }
    
    // Search for books by query and favorite status
    func search(query: String, isFavorite: Bool) async throws -> [Book] {
        return try await localSource.searchBooks(by: query, isFavorite: isFavorite)
    }
    
    // Mark book as favorite or not
    func favoriteMark(id: Int, isFavorite: Bool) async throws {
        try await localSource.markAsFavorite(id: id, isFav: isFavorite)
    }
}
