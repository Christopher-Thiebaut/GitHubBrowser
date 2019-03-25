//
//  Coordinator.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/25/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class GitHubRepositoryCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    let window: UIWindow
    
    let gitHubApi: GitHubAPI
    
    var repository = Repository(owner: "Christopher-Thiebaut", name: "Homeworld-Defender")
    
    var lastFetch: (repo: Repository, commits: [Commit])?
    
    let commitsViewController = CommitsTableViewController()
    
    init(gitHubApi: GitHubAPI) {
        window = UIWindow()
        navigationController = UINavigationController(rootViewController: commitsViewController)
        window.rootViewController = navigationController
//        self.navigationController = navigationController
        self.gitHubApi = gitHubApi
    }
    
    func start() {
        commitsViewController.commitSource = self
        window.makeKeyAndVisible()
//        navigationController.pushViewController(commitsViewController, animated: false)
    }

}

extension GitHubRepositoryCoordinator: CommitsDataSource {
    
    var cachedCommitHistory: [Commit]? {
        guard lastFetch?.repo == repository else {
            return nil
        }
        return lastFetch?.commits
    }
    
    func getCommits(completion: @escaping (Result<[Commit]>) -> Void) {
        if let cachedCommits = cachedCommitHistory {
            completion(.success(cachedCommits))
            return
        }
        gitHubApi.getCommitHistoryForRepository(repository.name, ownedBy: repository.owner, completion: completion)
    }
}
