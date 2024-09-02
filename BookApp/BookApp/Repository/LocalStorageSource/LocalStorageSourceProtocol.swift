//
//  LocalStorageSourceProtocol.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-30.
//

import Foundation

protocol LocalStorageSourceProtocol {
    func syncBooks(books: [Book]) async throws
    func fetchBooks() async throws -> [Book]
    func fetchFavorites() async throws -> [Int]
    func searchBooks(by query: String, isFavorite: Bool) async throws -> [Book]
    func markAsFavorite(id: Int, isFav: Bool) async throws
}
