//
//  Commit.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/23/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation
//
//struct Commit: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case hash = "oid"
//        case author
//        case message
//    }
//
//    let hash: String
//    let author: Author
//    let message: String
//}
//
//struct Author: Decodable {
//    let name: String
//}
struct Commit {
    let hash: String
    let author: String
    let message: String
    
    init(hash: String, author: String, message: String) {
        self.hash = hash
        self.author = author
        self.message = message
    }
}
