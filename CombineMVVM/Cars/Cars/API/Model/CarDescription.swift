//
//  CarDescription.swift
//  Cars
//
//  Created by Ravi Vora on 29/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

struct CarDescription {
    var description: String
}

extension CarDescription: Decodable {
    private enum CodingKeys: String, CodingKey {
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .description)
    }
}
