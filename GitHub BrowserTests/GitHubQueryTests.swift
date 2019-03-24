//
//  GitHubQueryTests.swift
//  GitHub BrowserTests
//
//  Created by Christopher Thiebaut on 3/23/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import XCTest

@testable import GitHub_Browser

class GitHubQueryTests: XCTestCase {

    func testRepoQueryCreation() {
        let christopherThiebaut = GitHubQuery.User(name: "Christopher-Thiebaut")
        let repostitoriesQuery = christopherThiebaut.getRepositoryNamesQuery(first: 100)
        //Known valid query determined by experimenting with Postman and GitHub's GraphQL Explorer
        let knownValidQuery =
"""
{ "query": "query { user(login: \\\"Christopher-Thiebaut\\\") { repositories(first: 100) { nodes { name } } } } "}
"""
        XCTAssertEqual(repostitoriesQuery, knownValidQuery)
    }
    
    func testRepoQueryResponseParsing() {
        let repoNames = GitHubQuery.User.decodeRepositoryNamesFrom(response: Data.repoQueryResponse) 
        XCTAssertEqual(repoNames.count, 12)
    }
}

fileprivate extension Data {
    static var repoQueryResponse: Data! {
        return """
        {"data":{"user":{"repositories":{"nodes":[{"name":"AndroidTest"},{"name":"FoodTracker"},{"name":"notes"},{"name":"BulletinBoard"},{"name":"Calculator"},{"name":"ProgramaticConstraintsWithAnimations"},{"name":"Checkers"},{"name":"RandomGroupPicker"},{"name":"Strategic-Marketing-Planner"},{"name":"Homeworld-Defender"},{"name":"OilChangeTracker"},{"name":"RxWeather"}]}}}}
        """.data(using: .utf8)
    }
}
