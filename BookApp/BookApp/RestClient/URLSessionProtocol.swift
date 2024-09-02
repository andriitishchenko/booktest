//
//  URLSessionProtocol.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    static func createConfiguredSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Timeout for individual requests, small value for demo
        configuration.timeoutIntervalForResource = 60 // Timeout for the overall resource
        
        return URLSession(configuration: configuration)
    }
    
}


