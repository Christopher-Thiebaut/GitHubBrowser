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
    
    var defaultRepository = Repository(owner: "Christopher-Thiebaut", name: "Homeworld-Defender")
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
