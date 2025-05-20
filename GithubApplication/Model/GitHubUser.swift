//
//  GitHubUser.swift
//  GithubApplication
//
//  Created by User on 16.05.25.
//

import Foundation

struct GitHubUser: Decodable {
    let login: String
    let avatar_url: URL
    let followers: Int
    let following: Int
    let public_repos: Int
    let bio: String?
}
