//
//  BookServiceProtocol.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation

protocol RemoteSourceProtocol {
    func fetchBooks() async throws -> [BookConvertible]
    func fetchBook(by id: Int) async throws -> BookConvertible
}
