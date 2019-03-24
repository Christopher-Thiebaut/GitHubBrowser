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
        let name: String
        
        var context: String {
            let userContext = "user(login: \\\"\(name)\\\") { %@ }"
            return String(format: GitHubQuery.context, arguments: [userContext])
        }
        
        init(name: String) {
            self.name = name
        }
        
        func getRepositoryNamesQuery(first count: Int) -> String {
            let repositoryContext = "repositories(first: \(count)) { %@ }"
            let queryContext = String(format: context, arguments: [repositoryContext])
            let namesQuery = "nodes { name }"
            return String(format: queryContext, arguments: [namesQuery])
        }
        
        class func decodeRepositoryNamesFrom(response: Data) -> [String] {
            do {
                let repoNameResponse = try JSONDecoder().decode(RepositoryResponse.self, from: response)
                return repoNameResponse.repositoryNames
            } catch let error {
                NSLog("Failed to decode repository names from response due to an error: \(error.localizedDescription)")
                return []
            }
        }
        
        struct RepositoryResponse: Decodable {
            let repositoryNames: [String]
            enum Data: String, CodingKey {
                case data
            }
            enum User: String, CodingKey {
                case user
            }
            enum Repositories: String, CodingKey {
                case repositories
            }
            enum Nodes: String, CodingKey {
                case nodes
            }
            enum Name: String, CodingKey {
                case name
            }
            init(from decoder: Decoder) throws {
                let data = try decoder.container(keyedBy: Data.self)
                let user = try data.nestedContainer(keyedBy: User.self, forKey: .data)
                let repositores = try user.nestedContainer(keyedBy: Nodes.self, forKey: .user)
                let nodes = try repositores.nestedContainer(keyedBy: Nodes.self, forKey: .nodes)
                var nameArray = try nodes.nestedUnkeyedContainer(forKey: .nodes)
                var repoNames = [String]()
                while !nameArray.isAtEnd {
                    let nameContainer = try nameArray.nestedContainer(keyedBy: Name.self)
                    let repoName = try nameContainer.decode(String.self, forKey: .name)
                    repoNames.append(repoName)
                }
                repositoryNames = repoNames
            }
        }
    }
}


