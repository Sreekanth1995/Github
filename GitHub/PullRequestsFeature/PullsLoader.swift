//
//  PullsLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 07/10/22.
//

import Foundation

protocol PullRequestsLoader {
    typealias Result = Swift.Result<[PullRequest], Error>
    
    func load(_ completion: @escaping (PullRequestsLoader.Result) -> Void)
}
