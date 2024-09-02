//
//  RestClient.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-28.
//

import Foundation

class RestClient {
    private let environment: ApiEnvironment
    private let session: URLSessionProtocol
    
    init(environment: ApiEnvironment = .development, session: URLSessionProtocol = URLSession.shared) {
        self.environment = environment
        self.session = session
    }
    
    // Fetch all books
    func fetchBooks() async throws -> [APIBook] {
        let url = environment.baseURL.appendingPathComponent("book")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await session.data(for: request)
            try self.validateHTTPResponse(response, data: data)
            let books = try JSONDecoder().decode([APIBook].self, from: data)
            return books
        } catch {
            throw self.mapError(error)
        }
    }
    
    // Fetch a book by ID - for demo only
    func fetchBook(by id: String) async throws -> APIBook {
        let url = environment.baseURL.appendingPathComponent("book/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await session.data(for: request)
            try self.validateHTTPResponse(response, data: data)
            let book = try JSONDecoder().decode(APIBook.self, from: data)
            return book
        } catch {
            throw self.mapError(error)
        }
    }
    
    // Validate HTTP response and check for API errors
    func validateHTTPResponse(_ response: URLResponse, data: Data) throws {
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            if let apiErrorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.apiError(message: apiErrorResponse.message)
            } else {
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
        }
    }
    
    // Map errors to the custom APIError type
    func mapError(_ error: Error) -> APIError {
        if let decodingError = error as? DecodingError {
            return APIError.decodingError(decodingError)
        } else if let urlError = error as? URLError {
            return APIError.networkError(urlError)
        } else if let apiError = error as? APIError {
            return apiError
        } else {
            return APIError.unknownError
        }
    }
}
