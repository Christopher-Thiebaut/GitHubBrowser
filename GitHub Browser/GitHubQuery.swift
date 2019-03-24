//
//  GitHubQuery.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/22/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation

class GitHubQuery {
    
    class var context: String {
        return "{ \"query\": \"query { %@ } \"}"
    }
    class User {
        
        enum ParsingError: Error {
            case invalidFormat
        }
        
        let name: String
        
        var context: String {
            let userContext = "user(login: \(name.asEscapedQuoteString)) { %@ }"
            return String(format: GitHubQuery.context, userContext)
        }
        
        init(name: String) {
            self.name = name
        }
        
        func getRepositoryNamesQuery(first count: Int) -> String {
            let repositoryContext = "repositories(first: \(count)) { %@ }"
            let queryContext = String(format: context, arguments: [repositoryContext])
            let namesQuery = "nodes { name }"
            return String(format: queryContext, namesQuery)
        }
        
        /*
         A couple of notes here:
         It may seem odd here to have the class that creates the query also be responsibe for decoding it. However, since GraphQL responses mirror the structure of the query itself it is best to have the class that determines the structure of the query also decode it.
         It may seem odd in 2019 to use JSONSerialization instead of Codable; however, Codable is designed to parse *objects* from JSON and a GraphQL response does not really consist of objects in a meaningful sense.  This caused the resulting Codable code to be unduly bloated and less clear than the comparable JSONSerializatin code.
         */
        class func decodeRepositoryNamesFrom(response: Data) -> [String] {
            do {
                var names = [String]()
                let root = try JSONSerialization.jsonObject(with: response) as? [String: Any] ?? [:]
                let data = root["data"] as? [String: Any]
                let user = data?["user"] as? [String: Any]
                let repos = user?["repositories"] as? [String: Any]
                guard let nodes = repos?["nodes"] as? Array<[String: Any]> else {
                    throw ParsingError.invalidFormat
                }
                for repo in nodes {
                    guard let repoName = repo["name"] as? String else { continue }
                    names.append(repoName)
                }
                return names
            } catch let error {
                NSLog("Failed to decode repository names due to an error: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    class Repository {
        let ownerName: String
        let repositoryName: String

        var context: String {
            let repositoryString = "repository(owner: \(ownerName.asEscapedQuoteString), name: \(repositoryName.asEscapedQuoteString)) { %@ }"
            return String(format: GitHubQuery.context, repositoryString)
        }

        init(ownerName: String, repositoryName: String) {
            self.ownerName = ownerName
            self.repositoryName = repositoryName
        }
        
        func getCommitHistoryQueryFor(branch: String, first count: Int) -> String {
            let refString = "ref(qualifiedName: \(branch.asEscapedQuoteString)) { %@ }"
            let refContext = String(format: context, refString)
            let targetContext = String(format: refContext, "target { %@ }")
            let commitContext = String(format: targetContext, "... on Commit { %@ }")
            let historyContext = String(format: commitContext, "history(first: \(count)) { %@ }")
            let nodesContext = String(format: historyContext, "nodes { %@ }")
            let author = "author { name }"
            let hash = "oid"
            return String(format: nodesContext, "\(hash) \(author) message")
        }
    }
}

extension String {
    var asEscapedQuoteString: String {
        return "\\\"\(self)\\\""
    }
}
