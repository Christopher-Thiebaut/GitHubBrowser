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
    
    func testRepoHistoryDecoding() {
        let commits = GitHubQuery.Repository.parseCommitsFrom(response: Data.historyQueryResponse)
        XCTAssertEqual(commits.count, 25)
    }
    
    //This test is for a special problem my the output for my Checkers Repository seems to have. Codable and JSONSerialization cannot parse. This is true for both the REST and GraphQL APIs
    func testDecodingFlakeyRepo() {
        let commits = GitHubQuery.Repository.parseCommitsFrom(response: Data.checkersRepositoryHistory)
        XCTAssertEqual(commits.count, 25)
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
        {"data":{"repository":{"ref":{"target":{"history":{"nodes":[{"oid":"8177fce971e5f3106293d2ba24358c88af3af0f3","author":{"name":"Christopher Thiebaut"},"message":"Merge pull request #1 from Christopher-Thiebaut/development\n\nMerge first app-store (according to me, not reviewed by Apple yet) ready version of game into master."},{"oid":"26f46587d3fe258c21eab53fa60fd4241f6aae50","author":{"name":"Christopher Thiebaut"},"message":"Remove particle sprite atlas no longer used."},{"oid":"e79acf4359bed053943dbf4fd86c17c11985c04b","author":{"name":"Christopher Thiebaut"},"message":"Fix bug in which a divide by 0 error would cause the app to crash on easy difficulty when showing the score breakdown."},{"oid":"6ac5b53cfa9a7fef1c1c500fbeb8a5d4603c2c60","author":{"name":"Christopher Thiebaut"},"message":"Change app icon.  Allow iPad.  Add art for iPad.  Give alien mothership physics body (this was overlooked when collisions collision detection was switch to all physics bodies."},{"oid":"23d1bcd94c99799578991c6b23a400b70b91a6a2","author":{"name":"Christopher Thiebaut"},"message":"Rename madness difficulty level.  Make score breakdown screen that shows raw score and effect of multiplier."},{"oid":"f8f0cd6dbf594eddb4b470c2c47bcecd4cc2a980","author":{"name":"Christopher Thiebaut"},"message":"Refactor so that hunter and raider now use the same entity but with different closures for targeting.  Start work on score breakdown in defeat screen.  Add getScoreMultiplier to Difficulty.  Modified alien firing range on hard and madness difficulty levels so that the aliens won't tend to shoot the player from off screen."},{"oid":"65d84ea2cce3ff9f298d4bba5d6e5fa877b210cc","author":{"name":"Christopher Thiebaut"},"message":"Fix a visual glitch in which buildings would momentarily appear in the wrong position on some loads"},{"oid":"a696edfb22b0bb04e16a86c91f7bc8e6b6720d8b","author":{"name":"Christopher Thiebaut"},"message":"Fixed reversed sign on most ContactHealthEffects.  Fixed HealthPack positioning."},{"oid":"743659aa49a9bf31c2502fb39907d614a834f089","author":{"name":"Christopher Thiebaut"},"message":"HealthPack add health to the player successfully. Renamed contact damage component because it doesn't only do damage anymore."},{"oid":"9501544824fc13fa978632816c9f8db961bd12bb","author":{"name":"Christopher Thiebaut"},"message":"Repair component almost finished."},{"oid":"d1491d582a8ddab2de779e371a13c7b778a229c9","author":{"name":"Christopher Thiebaut"},"message":"All collision detection is now based on SKPhysics bodies.  This saves a bunch of CPU time because there's no more polling for sprite overlaps.  Also replaced particle emitter with a small texture atlas for rocket animation. Looks much more consistent across devices and also saves a little bit of CPU time."},{"oid":"18ecfb180a164e4e1e0fd42b7baa058a4f9c91f3","author":{"name":"Christopher Thiebaut"},"message":"Add totally awesome background music from Spring at opengameart.org."},{"oid":"a57d35cf94a0d0994d8166d1947737ce7fcad31f","author":{"name":"Christopher Thiebaut"},"message":"Make re-work collision detection to use physics bodies instead of sprites if both entities have physics bodies. (Also make EntityController an SKPhysicsContactDelegate)"},{"oid":"ebb0efaa2f496f2e827605f5ede3e8e4dbe3a435","author":{"name":"Christopher Thiebaut"},"message":"Add reload bar on right side of screen that shows the time until the player can fire again.  Swapped out the sprite atlas for the player's ship for a red fighter more true to the game's original idea and a little less gritty/realistic looking to be more consistent with the rest of the game art."},{"oid":"9bf2561ed13ca16e6b0f9f5916d654a9f2224169","author":{"name":"Christopher Thiebaut"},"message":"Add settings menu with difficulty options.  They work pretty well."},{"oid":"149549edf5ef97b5274d8ca3871b8b536e532dd8","author":{"name":"Christopher Thiebaut"},"message":"Add an explosion sound effect with an SKAction.  Tried to use SKAudioNode, but it hurt the frame rate a lot for some reason.  Thinned out the explosion sprite atlas considerably for performance reasons."},{"oid":"10568fabb439be12d19b20599e8433418b22c2a3","author":{"name":"Christopher Thiebaut"},"message":"Make the alien mothership look way cooler by giving it a texture and a translucent energy shield. (shield counts toward size).  Make the aliens coming out of the mothership way less vulnerable to being picked off by the player by making the mothership thicker and making the aliens come out of a wider area."},{"oid":"d89b470ede094d5836a8f47bf3ae04ea13942a0a","author":{"name":"Christopher Thiebaut"},"message":"Adjust z positions of pause button, health bar, and score label so they can't get covered by the alien mothership."},{"oid":"78397042119d10787658f7ee8bbaa88509fd8724","author":{"name":"Christopher Thiebaut"},"message":"Add a nice tiled star background to the main scene."},{"oid":"8201b54afae594aa7fc26075cd8afd06beceaa5e","author":{"name":"Christopher Thiebaut"},"message":"Added Hunter entity which is another kind of alien that will try to hunt down and destroy the player instead of going after the buildings."},{"oid":"eecbfac44f49ad744f0d2e3d38ad653a77542702","author":{"name":"Christopher Thiebaut"},"message":"Stormtrooper offset for enemy agents is now managed by a Difficulty object.  More things, like firing interval, firing distances, retreat distances, and possibly speed will soon also be managed by difficulty level."},{"oid":"0be2f4ce873dee0b33949f730235f683277d1954","author":{"name":"Christopher Thiebaut"},"message":"Raider now makes target choice randomly. This reduces clustering of aliens and invalidates the strategy of sitting around and waiting for them to come in a line (since the aliens are now no longer positioned randomly.)"},{"oid":"841a71802db4c87dbd2529b12eccc518a76ce2b5","author":{"name":"Christopher Thiebaut"},"message":"Add a mothership entity that spawns aliens. (Mothership is currently a solid grey rectangle with no other components but its SpriteComponent, but hey.)"},{"oid":"9937aa32050824fff0a0833303e9d34e67b43f8e","author":{"name":"Christopher Thiebaut"},"message":"Switch collision avoidance behavior from agents to obstacles.  Also increased prediction time, which dramatically improved collision avoidance."},{"oid":"5bce262d2f3032ab54f81ad823bcfb2322aafaa4","author":{"name":"Christopher Thiebaut"},"message":"Make human ship and aliens significantly bigger."}]}}}}}}
        """.data(using: .utf8)
    }
        
        static var checkersRepositoryHistory: Data! {
            return """
                {"data":{"repository":{"ref":{"target":{"history":{"nodes":[{"oid":"2b5f927151a2f800cb14a0f2567e94cefd2493bf","author":{"name":"Christopher Thiebaut"},"message":"Merge pull request #3 from Christopher-Thiebaut/development\n\nDevelopment"},{"oid":"e260df433a86a0ee1f38cac58397888ac090a9fa","author":{"name":"Christopher Thiebaut"},"message":"Fix issue in which CheckersGameController was getting notified of selections with no valid moves in the case of double jumps."},{"oid":"90a7df1588918f6140108f2df03af1dabee26312","author":{"name":"Christopher Thiebaut"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"77e936453b9bba1b87d7743d66baa8976962d49b","author":{"name":"Christopher Thiebaut"},"message":"Removed failed attempt at local persistence. Will try again later. Maybe."},{"oid":"6d538bd8d7364293dfa4208736f929fd120a9e2b","author":{"name":"Isidore"},"message":"Black Button end turn will be upside down to accommodate cross-table play"},{"oid":"e030d93f89f3d725bc185928589d10261796ff90","author":{"name":"Isidore"},"message":"Merge branch 'development' into addingShakeGesture"},{"oid":"a26a205b40c51f3b8cd0963f37d12d890b36ecf8","author":{"name":"Isidore"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"8aa5c71e2fa942842e4f2591004b86512b83c2d5","author":{"name":"Isidore"},"message":"ActionController presents when phone is shaken"},{"oid":"882e82e4feddedb4a579d9840e4b925ae8eada48","author":{"name":"Christopher Thiebaut"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"0571484c14ca2afd955ffb63ce08f24846bb9552","author":{"name":"Christopher Thiebaut"},"message":"Update resetGame function to actually fully reset all game states.  Now also notifies delegate about active player change due to game reset."},{"oid":"45fa8192c50cf16bf5364e119ff4e165e98d14cb","author":{"name":"Isidore"},"message":"End Turn Button hides when it is not a players turn"},{"oid":"0d50832e148615f4b7803bc6d83ae1ab09aa2453","author":{"name":"Isidore"},"message":"End turn button will disappear when turn is over"},{"oid":"37ef025a228f57314a958f54ec008894d3217ca1","author":{"name":"Isidore"},"message":"Rounds highlighting on pieces selected"},{"oid":"ecf980c506f180761f28878490bcec95339facb8","author":{"name":"Isidore"},"message":"Implements end turn button switching players"},{"oid":"eeae41886ec1aa70272632065189a60c4ed030f6","author":{"name":"Isidore"},"message":"Renamed functions for end turn button event and reset game button event"},{"oid":"4ac2aed31ecb19785ef4fc65722f89f45682ace3","author":{"name":"Christopher Thiebaut"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"c9b582ee501ede5656546161db91f5cff132c7dc","author":{"name":"Christopher Thiebaut"},"message":"Organize project into folders.  Add empty PersistenceController that will later be used to save game state."},{"oid":"31c87371e91899ced7f3aa95349c3344d9f56820","author":{"name":"Isidore"},"message":"Merge remote-tracking branch 'origin/development' into development"},{"oid":"69adbeb442e0c8f7aece5059e0d6d5a2b13f59f9","author":{"name":"Isidore"},"message":"Game will reset when \"Play again pressed\""},{"oid":"ac11fd2ead21210a5e1b4b5f76b167981a30d332","author":{"name":"Christopher Thiebaut"},"message":"Fix bug in which reset does not change active player."},{"oid":"d7b54edec109b16be73a18914df0501f0465ca31","author":{"name":"Christopher Thiebaut"},"message":"Allow double jumps, YO!"},{"oid":"4de6fbee5cb68661eb330781c9a9e36c70ffb912","author":{"name":"Isidore"},"message":"Merge branch 'fixCollectionView' into development"},{"oid":"53be11c85d56108fa1e9fb113958106fbe6ee982","author":{"name":"Isidore"},"message":"CollectionView will have better spacing. Adds reset and end turn functionality to ui"},{"oid":"d24a161718304ca7c6fd9b5a3d835706b982deb6","author":{"name":"Christopher Thiebaut"},"message":"Working on implementing double jump. Buggy right now. Commented out offensive code. Pushing now because apparently didn't push on earlier commit."},{"oid":"3b005d65a0620439480ec2a5e21e742bb76581dd","author":{"name":"Isidore"},"message":"Merge remote-tracking branch 'origin/development' into development"}]}}}}}}
                """.data(using: .utf8)
        }
}
