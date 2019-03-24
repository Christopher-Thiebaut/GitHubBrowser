//
//  CommitResponseV3.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation

struct CommitResponseV3: Decodable {
    
    let commit: CommitEntry
    let sha: String
    
    struct CommitEntry: Decodable {
        let author: Author
        let message: String
    }
    
    struct Author: Decodable {
        let name: String
    }
    
    var asCommit: Commit {
        return Commit(hash: sha, author: commit.author.name, message: commit.message)
    }
}
