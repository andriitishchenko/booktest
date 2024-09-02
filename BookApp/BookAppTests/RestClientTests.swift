//
//  RestClientTests.swift
//  BookAppTests
//
//  Created by Andrii Tishchenko on 2024-09-01.
//

import XCTest
@testable import BookApp

final class RestClientTests: XCTestCase {
    
    var restClient: RestClient!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        restClient = RestClient(environment: .development, session: mockSession!)
    }
    
    override func tearDown() {
        restClient = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchBooksSuccess() async throws {
        // Given
        let jsonData = """
        [
            {"title": "Book 1", "author": "Author 1", "cover": "cover1.jpg", "description": "Description 1", "id": "1"},
            {"title": "Book 2", "author": "Author 2", "cover": "cover2.jpg", "description": "Description 2", "id": "2"}
        ]
        """.data(using: .utf8)!
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let books = try await restClient.fetchBooks()
        
        XCTAssertEqual(books.count, 2)
        XCTAssertEqual(books[0].title, "Book 1")
        XCTAssertEqual(books[0].cover, "cover1.jpg?lock=1")
    }
    
    func testFetchBooksFailure() async throws {
        mockSession.error = URLError(.notConnectedToInternet)
        
        do {
            _ = try await restClient.fetchBooks()
            XCTFail("Expected to throw, but did not throw")
        } catch {
            XCTAssertTrue(error is APIError)
//            XCTAssertEqual(error as? APIError, APIError.networkError(URLError(.notConnectedToInternet)))
        }
    }
    
    func testFetchBookByIdSuccess() async throws {
        let jsonData = """
        {"title": "Book 1", "author": "Author 1", "cover": "cover1.jpg", "description": "Description 1", "id": "1"}
        """.data(using: .utf8)!
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let book = try await restClient.fetchBook(by: "1")
        
        XCTAssertEqual(book.title, "Book 1")
        XCTAssertEqual(book.id, 1)
        XCTAssertEqual(book.cover, "cover1.jpg?lock=1")
    }
    
    func testFetchBookByIdFailure() async throws {
        // Given
        let jsonData = """
        {"type": "error", "message": "Book not found"}
        """.data(using: .utf8)!
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 404,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        do {
            _ = try await restClient.fetchBook(by: "999")
            XCTFail("Expected to throw, but did not throw")
        } catch {
            XCTAssertTrue(error is APIError)
            if case APIError.apiError(let message) = error as! APIError {
                XCTAssertEqual(message, "Book not found")
            } else {
                XCTFail("Unexpected error type")
            }
        }
    }
}
