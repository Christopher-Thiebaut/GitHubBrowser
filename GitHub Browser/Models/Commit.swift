//
//  Commit.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/23/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation

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
