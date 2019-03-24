//
//  Result.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    
    func get() throws -> T {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
