//
//  PullReqViewModel.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation

class PullRequestsViewModel {
    typealias Observer<T> = (T) -> Void
    private let loader: PullRequestsLoader
    
    var isLoading: Bool = false {
        didSet {
            onChange?(isLoading)
            if isLoading {
                onErrorMessageLoad?(nil)
            }
        }
    }
    
    var onChange: Observer<Bool>?
    var onPullReqsLoad: Observer<[PullRequest]>?
    var onErrorMessageLoad: Observer<Error?>?
    var title: String {
        "Pull Requests"
    }
    
    init(loader: PullRequestsLoader) {
        self.loader = loader
    }
    
    func loadPullRequests() {
        isLoading = true
        loader.load() {[weak self] result in
            switch result {
            case .success(let items):
                self?.onPullReqsLoad?(items)
            case .failure(let err):
                self?.onErrorMessageLoad?(err)
            }
            self?.isLoading = false
        }
    }
}
