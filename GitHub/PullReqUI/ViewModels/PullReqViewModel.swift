//
//  PullReqViewModel.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation

class PullRequestViewModel {
    private enum State {
        case pending
        case loading
        case failed
        case loaded([PullRequest])
    }
    
    private let loader: PullRequestsLoader
    
    var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }
    
    
    var onChange: ((PullRequestViewModel) -> Void)?
    var onPullReqsLoad: (([PullRequest]) -> Void)?
    
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
