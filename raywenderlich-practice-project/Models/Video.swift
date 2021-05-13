//
//  Video.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import Foundation

struct VideoAPIResponse: Codable {
    let data: [Video]
}

struct Video: Item {
    var id: Int
    var attributes: Attributes
    var type: ItemType = .video
}

extension Video: Codable {
    enum CodingKeys: CodingKey {
        case id
        case attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Video.CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        attributes = try container.decode(Attributes.self, forKey: .attributes)
    }
}
