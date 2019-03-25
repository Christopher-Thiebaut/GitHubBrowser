//
//  ViewController.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/22/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let gitHubService = GitHubAPIv4(tokenProvider: EnvironmentTokenProvider())
    
    var repos = [String]() {
        didSet {
            guard let first = repos.first else { return }
            loadCommits(for: first)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gitHubService.getRepositoryListForUser(user: "Christopher-Thiebaut") {[weak self] result in
            do {
                self?.repos = try result.get()
                print(self?.repos ?? [])
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
        
    }
    
    func loadCommits(for repo: String) {
        gitHubService.getCommitHistoryForRepository(repo, ownedBy: "Christopher-Thiebaut") { result in
            do {
                let commits = try result.get()
                print(commits)
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
    }


}

