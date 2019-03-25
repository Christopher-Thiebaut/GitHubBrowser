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
        self.gitHubApi = gitHubApi
    }
    
    func start() {
        commitsViewController.commitSource = self
        commitsViewController.delegate = self
        commitsViewController.title = "Commit Browser"
        window.makeKeyAndVisible()
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

extension GitHubRepositoryCoordinator: CommitsTableViewControllerDelegate {
    
    func getRepositoryName() -> String? {
        return repository.name
    }
    
    func navigateToChangeRepository() {
        let repoViewController = RepositoryTableViewController()
        repoViewController.delegate = self
        repoViewController.repoSource = self
        repoViewController.owner = repository.owner
        navigationController.pushViewController(repoViewController, animated: true)
    }
}

extension GitHubRepositoryCoordinator: RepositoryTableViewControllerDelegate {
    func selectedRepository(_ repository: Repository) {
        self.repository = repository
        navigationController.popToRootViewController(animated: true)
    }
}

extension GitHubRepositoryCoordinator: RepoSource {
    func getRepositoriesWithOwner(name: String, completion: @escaping (Result<[String]>) -> Void) {
        gitHubApi.getRepositoryListForUser(user: name, completion: completion)
    }
}
