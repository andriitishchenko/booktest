//
//  BookIntentHandlerTests.swift
//  BookAppTests
//
//  Created by Andrii Tishchenko on 2024-09-01.
//

import XCTest
@testable import BookApp

class BookIntentHandlerTests: XCTestCase {
    var mockRepository: MockRepository!
    var mockNetworkMonitor: MockNetworkMonitor!
    var intentHandler: BookIntentHandler!

    @MainActor override func setUp() {
        super.setUp()
        mockRepository = MockRepository()
        mockNetworkMonitor = MockNetworkMonitor()
        intentHandler = BookIntentHandler(repository: mockRepository)
    }

    @MainActor override func tearDown() {
        mockRepository = nil
        mockNetworkMonitor = nil
        intentHandler = nil
        super.tearDown()
    }

    func testLoadBooksSuccess() async {
        mockRepository.books = [
            Book(id: 1, title: "Mock Book", author: "Mock Author", coverImageURL: URL(string: "https://google.com"), text: "SOme text" )
        ]
        await intentHandler.handle(.loadBooks)
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.books.count, 1)
        }
    }
    
    func testLoadBooksFailure() async {
        mockRepository.error = NSError(domain: "", code: -1, userInfo: nil)
        await intentHandler.handle(.loadBooks)
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.error, "Failed to load books: Error Domain= Code=-1 \"(null)\"")
        }
    }
        
    func testNetworkConnectionLost() async {
        // Simulate connection lost
        var iterator = mockNetworkMonitor.statusStream.makeAsyncIterator()
        _ = await iterator.next()
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.error, "No internet connection")
        }
    }
    
    func testNetworkConnectionRestored() async {
        // Simulate connection lost and restored
        var iterator = mockNetworkMonitor.statusStream.makeAsyncIterator()
        _ = await iterator.next() // Simulate offline
        _ = await iterator.next() // Simulate online
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.error, "")
        }
    }
    
    func testFavoriteMarking() async {
        // Initially no favorites
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.favorites.count, 0)
        }
        
        // Mark a book as favorite
        await intentHandler.handle(.favoriteMark(id: 1, isFavorite: true))
        
        // Check if the book is added to favorites
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.favorites.count, 1)
            XCTAssertEqual(intentHandler.state.favorites.first, 1)
        }
        
        // Unmark the favorite
        await intentHandler.handle(.favoriteMark(id: 1, isFavorite: false))
        
        // Check if the book is removed from favorites
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.favorites.count, 0)
        }
    }
    
    func testSearchBooks() async {
        mockRepository.books = [
            Book(id: 1, title: "Mock Book", author: "Mock Author", coverImageURL: URL(string: "https://google.com"), text: "Some text" ),
            Book(id: 2, title: "Mock Book 2", author: "Mock Author 2", coverImageURL: URL(string: "https://google.com"), text: "Some text" )
        ]
        
        await intentHandler.handle(.searchBooks(query: "Mock"))
        
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.searchResults.count, 2)
        }
        
        await intentHandler.handle(.searchBooks(query: "Mock Book 2"))
        
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.searchResults.count, 1)
            XCTAssertEqual(intentHandler.state.searchResults.first?.title, "Mock Book 2")
        }
    }
    
    func testLoadFavorites() async {
        mockRepository.favorites = [1]
        mockRepository.books = [
            Book(id: 1, title: "Mock Book", author: "Mock Author", coverImageURL: URL(string: "https://google.com"), text: "Some text" ),
            Book(id: 2, title: "Mock Book 2", author: "Mock Author 2", coverImageURL: URL(string: "https://google.com"), text: "Some text" )
        ]
        
        await intentHandler.handle(.loadFavorite)
        
        await MainActor.run {
            XCTAssertEqual(intentHandler.state.favorites.count, 1)
            XCTAssertEqual(intentHandler.state.favorites.first, 1)
        }
    }
}
