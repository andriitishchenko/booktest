//
//  MockURLSession.swift
//  BookAppTests
//
//  Created by Andrii Tishchenko on 2024-09-01.
//

import Foundation
@testable import BookApp

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request, delegate: nil)
    }
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
