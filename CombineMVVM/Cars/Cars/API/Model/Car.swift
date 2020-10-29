//
//  Car.swift
//  Cars
//
//  Created by Ravi Vora on 29/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

struct Car {
    var id: Int64
    var title: String
    var dateTime: String
    var image: String
    let content: [CarDescription]
}

extension Car: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case dateTime
        case image
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        dateTime = try container.decode(String.self, forKey: .dateTime)
        image = try container.decode(String.self, forKey: .image)
        content = try container.decode([CarDescription].self, forKey: .content)
    }
}
