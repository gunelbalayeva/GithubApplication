//
//  DIContainer.swift
//  GithubApplication
//
//  Created by User on 16.05.25.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    lazy var networkService: NetworkService = URLSessionNetworkService()
    lazy var gitHubAPI: GitHubAPIProtocol = GitHubAPI(service: networkService)
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(api: gitHubAPI)
    }
}
