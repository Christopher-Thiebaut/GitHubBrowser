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
    let commitViewController = CommitsTableViewController()
    
    var repos = [String]() {
        didSet {
            guard let last = repos.last else { return }
            loadCommits(for: last)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        embedCommitsVC()
        gitHubService.getRepositoryListForUser(user: "Christopher-Thiebaut") {[weak self] result in
            do {
                self?.repos = try result.get()
                print(self?.repos ?? [])
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func embedCommitsVC() {
        addChild(commitViewController)
        view.addSubview(commitViewController.view)
        let commitsView: UIView = commitViewController.view
        commitsView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        commitsView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        commitsView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        commitsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        commitsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    func loadCommits(for repo: String) {
        gitHubService.getCommitHistoryForRepository(repo, ownedBy: "Christopher-Thiebaut") { [weak self] result in
            do {
                let commits = try result.get()
                DispatchQueue.main.async {
                    self?.commitViewController.commits = commits
                }
                print(commits)
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
    }


}

