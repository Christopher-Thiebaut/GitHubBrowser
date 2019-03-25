//
//  CommitsTableViewController.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import UIKit

final class CommitsTableViewController: UITableViewController {

    var commits = [Commit]() {
        didSet {
            tableView.reloadData()
        }
    }
    var showLoadingUI = true {
        didSet {
            updateLoadingUI()
        }
    }
    
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
        updateLoadingUI()
        let nib = UINib(nibName: CommitTableViewCell.nibName, bundle: Bundle(for: CommitTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: CommitTableViewCell.nibName)
    }
    
    func updateLoadingUI() {
        if showLoadingUI {
            let backgroundView = UIView()
//            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            let loadingLabel = UILabel()
            loadingLabel.translatesAutoresizingMaskIntoConstraints = false
            loadingLabel.text = "Loading Commits..."
            backgroundView.addSubview(loadingLabel)
            loadingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            loadingLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
            tableView.backgroundView = backgroundView
        } else {
            tableView.backgroundView = nil
        }
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
    
}
