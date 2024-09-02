//
//  Environment.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation

enum ApiEnvironment {
    case development
    case production

    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://dev/api/v1/")!
        case .production:
            return URL(string: "https://66cf016f901aab2484207fcc.mockapi.io/api/v1/")!
        }
    }
}
