//
//  LocalStorageSource.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-30.
//

import Foundation

extension BookItem: BookConvertible {
    func toBook() -> Book {
        return Book(
            id: Int(id),
            title: title ?? "",
            author: author ?? "",
            coverImageURL: URL(string: (coverImageURL!)),
            text: bookDescription
        )
    }
}


class LocalStorageSource: LocalStorageSourceProtocol {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchBooks() async -> [Book] {
        let booksRaw = coreDataManager.fetchBooks()
        return booksRaw.map { $0.toBook() }
    }
    
    func markAsFavorite(id: Int, isFav: Bool) async {
        if isFav {
             coreDataManager.markBookAsFavorite(by: id)
        } else {
             coreDataManager.removeBookFromFavorites(by: id)
        }
    }
    
    func fetchFavorites() async -> [Int] {
        let booksRaw = coreDataManager.fetchFavoriteBooks()
        return booksRaw.map { Int($0.id) }
    }
    
    func syncBooks(books: [Book]) async {
         coreDataManager.syncBooks(books: books)
    }
    
    func searchBooks(by titleOrAuthor: String) async -> [Book] {
        let booksRaw = coreDataManager.searchBooks(by: titleOrAuthor)
        return booksRaw.map { $0.toBook() }
    }
    
    func searchBooks(by query: String, isFavorite: Bool) async throws -> [Book] {
        let booksRaw = coreDataManager.searchBooks(by: query)
        return booksRaw.map { $0.toBook() }
    }
}
