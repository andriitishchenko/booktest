//
//  Book.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-27.
//

import Foundation

struct Book: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let author: String
    let coverImageURL: URL?
    let text: String?
}

protocol BookConvertible {
    func toBook() -> Book
}

func convert<T: BookConvertible>(_ convertible: T) -> Book {
    return convertible.toBook()
}

