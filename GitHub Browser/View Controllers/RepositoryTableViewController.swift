//
//  RepositoryTableViewController.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/25/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol RepositoryTableViewControllerDelegate: class {
    func selectedRepository(_ repository: Repository)
}

protocol RepoSource: class {
    func getRepositoriesWithOwner(name: String, completion: @escaping (Result<[String]>) -> Void)
}

class RepositoryTableViewController: UITableViewController, TextShower {
    
    weak var delegate: RepositoryTableViewControllerDelegate?
    weak var repoSource: RepoSource?
    
    private var ownerTextField = UITextField()
    
    var owner: String? {
        get {
            return ownerTextField.text
        }
        set {
            ownerTextField.text = newValue
        }
    }
    
    var repositories = [Repository]() {
        didSet {
            showText(text: nil)
            tableView.reloadData()
        }
    }
    
    let cellReuseId = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchForRepositories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let repoName = repositories[indexPath.row].name
        cell.textLabel?.text = repoName
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = UIView()
        headerView.backgroundColor = .white
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("Search Repositories", for: .normal)
        searchButton.addTarget(self, action: #selector(searchForRepositories), for: .touchUpInside)
        let headerContents = UIStackView(arrangedSubviews: [ownerTextField, searchButton])
        headerContents.axis = .horizontal
        headerContents.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerContents)
        headerContents.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
        headerContents.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8).isActive = true
        headerContents.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8).isActive = true
        headerContents.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedRepository(repositories[indexPath.row])
    }
    
    @objc func searchForRepositories() {
        guard let ownerName = ownerTextField.text, ownerName.count > 0 else { return }
        showText(text: "Loading Repositories...")
        repoSource?.getRepositoriesWithOwner(name: ownerName, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repoNames):
                    self?.repositories = repoNames.map { Repository(owner: ownerName, name: $0) }
                case .failure(_):
                    self?.showText(text: "There was an error loading repositories for \(ownerName)")
                }
            }
        })
    }

}
