//
//  BookService.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation

extension APIBook: BookConvertible {
    func toBook() -> Book {
        return Book(
            id: Int(id) ,
            title: title,
            author: author,
            coverImageURL: URL(string: cover),
            text: text
        )
    }
}

class RemoteSource: RemoteSourceProtocol {
    private let restClient: RestClient
    
    init(restClient: RestClient) {
        self.restClient = restClient
    }
    
    func fetchBooks() async throws -> [BookConvertible] {
        do {
            let apiBooks = try await restClient.fetchBooks()
            return apiBooks.map { $0 }
        } catch {
            // Handle and propagate the error
            throw error
        }
    }
    
    func fetchBook(by id: Int) async throws -> BookConvertible {
        do {
            let book = try await restClient.fetchBook(by: "\(id)")
            return book
        } catch {
            // Handle and propagate the error
            throw error
        }
    }
}
