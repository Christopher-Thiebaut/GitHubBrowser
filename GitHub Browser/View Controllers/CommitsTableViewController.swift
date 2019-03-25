//
//  CommitsTableViewController.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol CommitsDataSource: class {
    func getCommits(completion: @escaping (Result<[Commit]>) -> Void)
}

protocol CommitsTableViewControllerDelegate: class {
    func getRepositoryName() -> String?
    func navigateToChangeRepository()
}

final class CommitsTableViewController: UITableViewController, TextShower {
    
    var commits = [Commit]() {
        didSet {
            tableView.reloadData()
            guard commits.count > 0 else {
                showText(text: "Looks like there's no commits here.")
                return
            }
            showText(text: nil)
        }
    }
    
    weak var commitSource: CommitsDataSource?
    weak var delegate: CommitsTableViewControllerDelegate?
    
    init() {
        super.init(style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: CommitTableViewCell.nibName, bundle: Bundle(for: CommitTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: CommitTableViewCell.nibName)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showText(text: "Loading Commits...")
        commitSource?.getCommits(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let commits):
                    self?.commits = commits
                case .failure(_):
                    self?.showText(text: "There was an error loading those commits. Please try again later.")
                }
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commitCell: CommitTableViewCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.nibName, for: indexPath) as? CommitTableViewCell {
            commitCell = cell
        } else {
            commitCell = CommitTableViewCell(frame: CGRect.zero)
        }
        let commit = commits[indexPath.row]
        commitCell.nameLabel.text = commit.author
        commitCell.hashLabel.text = commit.hash
        commitCell.messageLabel.text = commit.message
        return commitCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let repoName = delegate?.getRepositoryName(), section == 0 else { return nil }
        let headerView = UIView()
        headerView.backgroundColor = .white
        let changeButton = UIButton(type: .system)
        changeButton.setTitle("Change", for: .normal)
        changeButton.addTarget(self, action: #selector(navigateToChangeRepos), for: .touchUpInside)
        let currentRepositoryLabel = UILabel()
        currentRepositoryLabel.text = "Viewing: \(repoName)"
        let headerContents = UIStackView(arrangedSubviews: [currentRepositoryLabel, changeButton])
        headerContents.axis = .horizontal
        headerContents.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerContents)
        headerContents.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
        headerContents.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8).isActive = true
        headerContents.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8).isActive = true
        headerContents.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        return headerView
    }
    
    @objc func navigateToChangeRepos() {
        delegate?.navigateToChangeRepository()
    }
    
}

protocol TextShower {
    func showText(text: String?)
}

extension TextShower where Self: UITableViewController {
    func showText(text: String?) {
        if let text = text {
            let backgroundView = UIView()
            let loadingLabel = UILabel()
            loadingLabel.translatesAutoresizingMaskIntoConstraints = false
            loadingLabel.text = text
            backgroundView.addSubview(loadingLabel)
            loadingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            loadingLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
            tableView.backgroundView = backgroundView
        } else {
            tableView.backgroundView = nil
        }
    }
}
