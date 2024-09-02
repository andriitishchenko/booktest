//
//  APIError.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation

enum APIError: Error {
    case networkError(URLError)
    case serverError(statusCode: Int)
    case apiError(message: String)
    case decodingError(DecodingError)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let urlError):
            return urlError.localizedDescription
        case .serverError(let statusCode):
            return "Server returned status code \(statusCode)."
        case .apiError(let message):
            return "API Error: \(message)"
        case .decodingError(let decodingError):
            return "Decoding Error: \(decodingError.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
