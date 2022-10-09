//
//  PullRequest.swift
//  GitHub
//
//  Created by M sreekanth  on 07/10/22.
//

import Foundation

struct PullRequest: Equatable {
    let id: Int
    let url: URL
    let number: Int
    let state: String
    let title: String?
    let createdAt: String?
    let closedAt: String?
    let body: String?
    let userImage: URL?
    let userName: String?
    let repo: String?
    
    init(id: Int,
         url: URL,
         number: Int,
         state: String,
         body: String?,
         title: String?,
         createdAt: String?,
         closedAt: String?,
         userName: String?,
         userImage: URL?,
         repo: String?) {
        self.id = id
        self.url = url
        self.number = number
        self.state = state
        self.body = body
        self.title = title
        self.createdAt = createdAt
        self.closedAt = closedAt
        self.userName = userName
        self.userImage = userImage
        self.repo = repo
    }
}
