//
//  ProfileViewModel.swift
//  GithubApplication
//
//  Created by User on 16.05.25.
//

import Foundation
import Foundation

class ProfileViewModel {
    private let api: GitHubAPIProtocol
    var onUpdate: (() -> Void)?
    private(set) var user: GitHubUser?
    
    init(api: GitHubAPIProtocol) {
        self.api = api
    }
    
    func fetchUser(username: String) {
        api.getUser(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.onUpdate?()
                case .failure(let error):
                    print("Error fetching user:", error)
                    
                }
            }
        }
    }
}
