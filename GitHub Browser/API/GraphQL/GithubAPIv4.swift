//
//  GithubAPIv4.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case noData
    case badResponseCode(Int)
}

protocol GitHubAPI {
    func getRepositoryListForUser(user: String, completion: @escaping (Result<[String]>) -> Void)
    func getCommitHistoryForRepository(_ repository: String, ownedBy owner: String, completion: @escaping (Result<[Commit]>) -> Void)
}

class GitHubAPIv4: GitHubAPI {
    
    private let urlSession: URLSession
    private let tokenProvider: TokenProvider
    private let endpoint = URL(string: "https://api.github.com/graphql")!
    
    init(urlSession: URLSession = URLSession.shared, tokenProvider: TokenProvider) {
        self.urlSession = urlSession
        self.tokenProvider = tokenProvider
    }
    
    func getRepositoryListForUser(user: String, completion: @escaping (Result<[String]>) -> Void) {
        do {
            let query = GitHubQuery.User(name: user).getRepositoryNamesQuery(first: 100)
            let request = try buildRequestWithQuery(query)
            getModelsWithRequest(request, modelProducingClosure: GitHubQuery.User.decodeRepositoryNamesFrom, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func getCommitHistoryForRepository(_ repository: String, ownedBy owner: String, completion: @escaping (Result<[Commit]>) -> Void) {
        do {
            let repo = GitHubQuery.Repository(ownerName: owner, repositoryName: repository)
            let query = repo.getCommitHistoryQueryFor(branch: "master", first: 25)//.User(name: user).getRepositoryNamesQuery(first: 100)
            let request = try buildRequestWithQuery(query)
            getModelsWithRequest(request, modelProducingClosure: GitHubQuery.Repository.parseCommitsFrom, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func getModelsWithRequest<T>(_ request: URLRequest, modelProducingClosure: @escaping (Data) throws -> T, completion: @escaping (Result<T>) -> Void) {
        fetchData(withRequest: request) { result in
            do {
                let data = try result.get()
                let model = try modelProducingClosure(data)
                completion(.success(model))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    

    private func fetchData(withRequest request: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        urlSession.dataTask(with: request) { (data, response, error) in
            let httpStatus = (response as? HTTPURLResponse)?.statusCode ?? 200
            do {
                if let error = error { throw error }
                guard !(200..<300).contains(httpStatus) else { throw FetchError.badResponseCode(httpStatus) }
                guard let data = data else { throw FetchError.noData }
                completion(.success(data))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    private func buildRequestWithQuery(_ query: String) throws -> URLRequest {
        let token = try tokenProvider.getToken()
        var request = URLRequest(url: endpoint)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
        request.httpBody = query.data(using: .utf8)
        return request
    }
}
