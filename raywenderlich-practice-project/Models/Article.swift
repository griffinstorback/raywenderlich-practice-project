//
//  Article.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import Foundation

struct ArticleAPIResponse: Codable {
    let data: [Article]
}

struct Article: Item {
    var id: Int
    var attributes: Attributes
    var type: ItemType = .article
}

extension Article: Codable {
    enum CodingKeys: CodingKey {
        case id
        case attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Article.CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        attributes = try container.decode(Attributes.self, forKey: .attributes)
    }
}
