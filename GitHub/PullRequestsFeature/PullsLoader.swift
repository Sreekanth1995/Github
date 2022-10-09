//
//  PullsLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 07/10/22.
//

import Foundation

enum LoadPullRequestsResult {
    case success([PullRequest])
    case failure(Error)
}

protocol PullRequestsLoader {
    func load(_ completion: @escaping (LoadPullRequestsResult) -> Void)
}
