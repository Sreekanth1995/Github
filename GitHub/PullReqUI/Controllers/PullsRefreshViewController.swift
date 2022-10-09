//
//  PullsRefreshViewController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullsRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    let loader: PullRequestsLoader
    var onRefresh: (([PullRequest]) -> Void)?
    
    init(loader: PullRequestsLoader) {
        self.loader = loader
    }
    
    @objc func refresh() {
        view.beginRefreshing()
        loader.load() {[weak self] result in
            guard let self = self else { return }
            self.view.endRefreshing()
            switch result {
            case .success(let pulls):
                self.onRefresh?(pulls)
            case .failure(let error):
                break
            }
        }
    }
}


