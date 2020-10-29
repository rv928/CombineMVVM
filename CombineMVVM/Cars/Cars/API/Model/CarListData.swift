//
//  CarListData.swift
//  Cars
//
//  Created by Ravi Vora on 29/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

struct CarListData {
    let content: [Car]
}

extension CarListData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode([Car].self, forKey: .content)
    }
}
