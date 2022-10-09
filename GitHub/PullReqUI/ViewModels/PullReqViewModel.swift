//
//  PullReqViewModel.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation

class PullRequestViewModel {
    typealias Observer<T> = (T) -> Void
    private let loader: PullRequestsLoader
    
    var isLoading: Bool = false {
        didSet {
            onChange?(isLoading)
        }
    }
    
    var onChange: Observer<Bool>?
    var onPullReqsLoad: Observer<[PullRequest]>?
    
    init(loader: PullRequestsLoader) {
        self.loader = loader
    }
    
    func loadPullRequests() {
        isLoading = true
        loader.load() {[weak self] result in
            if let pulls = try? result.get() {
                self?.onPullReqsLoad?(pulls)
            }
            self?.isLoading = false
        }
    }
}
