//
//  GitHubAPI.swift
//  GithubApplication
//
//  Created by User on 17.05.25.
//

import Foundation

protocol GitHubAPIProtocol {
    func getUser(username: String, completion: @escaping (Result<GitHubUser, Error>) -> Void)
}

class GitHubAPI: GitHubAPIProtocol {
    private let service: NetworkService
    init(service: NetworkService) {
        self.service = service
    }
    func getUser(username: String, completion: @escaping (Result<GitHubUser, Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain:"InvalidURL", code:0)))
            
            return
        }
        service.fetch(url: url, completion: completion)
    }
}
