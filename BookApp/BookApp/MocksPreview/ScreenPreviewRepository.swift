//
//  ScreenPreviewRepository.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-31.
//

import Foundation


class ScreenPreviewRepository: Repository {
    var books:[Book]
    
    init() {
        books = []
        for i in 1..<10 {
            let book = Book(id: i, title: "Title text \(i) book string ", author: "Good \(i) Author", coverImageURL: URL(string: "https://loremflickr.com/640/480/abstract?lock=\(i)"), text:"Loren \(i) impus a dollar Loren impus a dollar Loren impus a dollar Loren impus a dollar Loren impus a dollar")
            books.append(book)
        }
    }
    
    func syncBooks() {
        
    }
    
    func fetchBooks() -> [Book] {
        return books
    }
    
    func fetchFavorites() -> [Int] {
        return books[ 1..<3 ].map{ $0.id }
    }
    
    func search(query: String, isFavorite: Bool) -> [Book] {
        let s = books.prefix(3)
        return Array(s)
    }
    
    func favoriteMark(id: Int, isFavorite: Bool) {
        
    }
    
    
}
