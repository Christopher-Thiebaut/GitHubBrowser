//
//  TokenProvider.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation

protocol TokenProvider {
    func getToken() throws -> String
}

enum TokenError: Error {
    case noTokenAvailable
}

class EnvironmentTokenProvider: TokenProvider {
    func getToken() throws -> String {
        guard let token = ProcessInfo.processInfo.environment["github-access-token"] else {
            throw TokenError.noTokenAvailable
        }
        return token
    }
}
