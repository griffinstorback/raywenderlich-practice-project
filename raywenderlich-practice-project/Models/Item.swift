//
//  Item.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import Foundation

enum DisplayItemType {
    case articles
    case videos
    case both
}

enum ItemType: String {
    case article
    case collection
}

struct ItemAPIResponse: Codable {
    let data: [Item]
}

struct Item: Hashable {
    var id: String
    var attributes: Attributes
}

extension Item: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Item.CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        attributes = try container.decode(Attributes.self, forKey: .attributes)
    }
}
