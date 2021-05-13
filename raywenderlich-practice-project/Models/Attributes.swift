//
//  Attributes.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-05.
//

import Foundation

struct Attributes: Codable, Hashable {
    let uri: String
    let name: String
    let releaseDate: String
    let contentType: String
    let description: String
    let descriptionPlainText: String
    let artworkImageURL: String
    let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case uri
        case name
        case releaseDate = "released_at"
        case contentType = "content_type"
        case description
        case descriptionPlainText = "description_plain_text"
        case artworkImageURL = "card_artwork_url"
        case duration
    }
}
