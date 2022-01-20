//
//  User.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/18.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
    
}
