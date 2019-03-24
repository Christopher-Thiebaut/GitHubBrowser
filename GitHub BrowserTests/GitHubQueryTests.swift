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
    
    func testRepoHistoryQueryCreation() {
        let checkers = GitHubQuery.Repository(ownerName: "Christopher-Thiebaut", repositoryName: "Checkers")
        let historyQuery = checkers.getCommitHistoryQueryFor(branch: "master", first: 25)
        let knownValidQuery =
        """
        { "query": "query { repository(owner: \\\"Christopher-Thiebaut\\\", name: \\\"Checkers\\\") { ref(qualifiedName: \\\"master\\\") { target { ... on Commit { history(first: 25) { nodes { oid author { name } message } } } } } } } "}
        """
        XCTAssertEqual(historyQuery, knownValidQuery)
    }
}

fileprivate extension Data {
    static var repoQueryResponse: Data! {
        return """
        {"data":{"user":{"repositories":{"nodes":[{"name":"AndroidTest"},{"name":"FoodTracker"},{"name":"notes"},{"name":"BulletinBoard"},{"name":"Calculator"},{"name":"ProgramaticConstraintsWithAnimations"},{"name":"Checkers"},{"name":"RandomGroupPicker"},{"name":"Strategic-Marketing-Planner"},{"name":"Homeworld-Defender"},{"name":"OilChangeTracker"},{"name":"RxWeather"}]}}}}
        """.data(using: .utf8)
    }
    
    static var historyQueryResponse: Data! {
        return """
        {"data":{"repository":{"name":"Checkers","ref":{"target":{"history":{"nodes":[{"oid":"2b5f927151a2f800cb14a0f2567e94cefd2493bf","author":{"name":"Christopher Thiebaut"},"message":"Merge pull request #3 from Christopher-Thiebaut/development\n\nDevelopment"},{"oid":"e260df433a86a0ee1f38cac58397888ac090a9fa","author":{"name":"Christopher Thiebaut"},"message":"Fix issue in which CheckersGameController was getting notified of selections with no valid moves in the case of double jumps."},{"oid":"90a7df1588918f6140108f2df03af1dabee26312","author":{"name":"Christopher Thiebaut"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"77e936453b9bba1b87d7743d66baa8976962d49b","author":{"name":"Christopher Thiebaut"},"message":"Removed failed attempt at local persistence. Will try again later. Maybe."},{"oid":"6d538bd8d7364293dfa4208736f929fd120a9e2b","author":{"name":"Isidore"},"message":"Black Button end turn will be upside down to accommodate cross-table play"},{"oid":"e030d93f89f3d725bc185928589d10261796ff90","author":{"name":"Isidore"},"message":"Merge branch 'development' into addingShakeGesture"},{"oid":"a26a205b40c51f3b8cd0963f37d12d890b36ecf8","author":{"name":"Isidore"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"8aa5c71e2fa942842e4f2591004b86512b83c2d5","author":{"name":"Isidore"},"message":"ActionController presents when phone is shaken"},{"oid":"882e82e4feddedb4a579d9840e4b925ae8eada48","author":{"name":"Christopher Thiebaut"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"0571484c14ca2afd955ffb63ce08f24846bb9552","author":{"name":"Christopher Thiebaut"},"message":"Update resetGame function to actually fully reset all game states.  Now also notifies delegate about active player change due to game reset."},{"oid":"45fa8192c50cf16bf5364e119ff4e165e98d14cb","author":{"name":"Isidore"},"message":"End Turn Button hides when it is not a players turn"},{"oid":"0d50832e148615f4b7803bc6d83ae1ab09aa2453","author":{"name":"Isidore"},"message":"End turn button will disappear when turn is over"},{"oid":"37ef025a228f57314a958f54ec008894d3217ca1","author":{"name":"Isidore"},"message":"Rounds highlighting on pieces selected"},{"oid":"ecf980c506f180761f28878490bcec95339facb8","author":{"name":"Isidore"},"message":"Implements end turn button switching players"},{"oid":"eeae41886ec1aa70272632065189a60c4ed030f6","author":{"name":"Isidore"},"message":"Renamed functions for end turn button event and reset game button event"},{"oid":"4ac2aed31ecb19785ef4fc65722f89f45682ace3","author":{"name":"Christopher Thiebaut"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"c9b582ee501ede5656546161db91f5cff132c7dc","author":{"name":"Christopher Thiebaut"},"message":"Organize project into folders.  Add empty PersistenceController that will later be used to save game state."},{"oid":"31c87371e91899ced7f3aa95349c3344d9f56820","author":{"name":"Isidore"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"69adbeb442e0c8f7aece5059e0d6d5a2b13f59f9","author":{"name":"Isidore"},"message":"Game will reset when \"Play again pressed\""},{"oid":"ac11fd2ead21210a5e1b4b5f76b167981a30d332","author":{"name":"Christopher Thiebaut"},"message":"Fix bug in which reset does not change active player."},{"oid":"d7b54edec109b16be73a18914df0501f0465ca31","author":{"name":"Christopher Thiebaut"},"message":"Allow double jumps, YO!"},{"oid":"4de6fbee5cb68661eb330781c9a9e36c70ffb912","author":{"name":"Isidore"},"message":"Merge branch 'fixCollectionView' into development"},{"oid":"53be11c85d56108fa1e9fb113958106fbe6ee982","author":{"name":"Isidore"},"message":"CollectionView will have better spacing. Adds reset and end turn functionality to ui"},{"oid":"d24a161718304ca7c6fd9b5a3d835706b982deb6","author":{"name":"Christopher Thiebaut"},"message":"Working on implementing double jump. Buggy right now. Commented out offensive code. Pushing now because apparently didn't push on earlier commit."},{"oid":"3b005d65a0620439480ec2a5e21e742bb76581dd","author":{"name":"Isidore"},"message":"Merge remote-tracking branch 'origin/development' into development"}]}}}}}}
        """.data(using: .utf8)
    }
}
