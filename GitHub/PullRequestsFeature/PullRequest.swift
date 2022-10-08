//
//  PullRequest.swift
//  GitHub
//
//  Created by M sreekanth  on 07/10/22.
//

import Foundation

struct PullRequest: Codable, Equatable {
    let url: URL
    let id: Int
    let state: String
    let title: String?
    let createdAt: String?
    let closedAt: String?
    let body: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case id
        case state
        case title
        case body
        case createdAt = "created_at"
        case closedAt = "closed_at"
    }
    
    init(id: Int,
         url: URL,
         state: String,
         body: String?,
         title: String?,
         createdAt: String?,
         closedAt: String?) {
        self.id = id
        self.url = url
        self.state = state
        self.body = body
        self.title = title
        self.createdAt = createdAt
        self.closedAt = closedAt
    }
}
