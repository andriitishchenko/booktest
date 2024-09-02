//
//  APIBook.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-29.
//

import Foundation

//JSON structure of a Book obj
struct APIBook: Identifiable, Codable {
    let title: String
    let author: String
    let cover: String
    let text: String
    let id: Int
    
    // Custom initializer to decode and modify the 'cover' property
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode all properties
        let idString = try container.decode(String.self, forKey: .id)
        guard let idInt = Int(idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "ID could not be converted to Int")
        }
        self.id = idInt
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        self.text = try container.decode(String.self, forKey: .text)
        
        let cover_url = try container.decode(String.self, forKey: .cover)
        // Append the string to the cover URL to make it const
        self.cover =  cover_url + "?lock=\(id)"
    }
    
    // Coding keys to map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case text = "description"
        case title
        case author
        case cover
        case id
    }
}

//JSON structure of Error obj, assume we have it
struct APIErrorResponse: Decodable {
    let type: String
    let message: String
}
