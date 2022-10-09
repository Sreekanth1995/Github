//
//  PullsRefreshViewController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullsRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = binded(view: UIRefreshControl())
    let viewModel: PullRequestViewModel
    
    init(viewModel: PullRequestViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadPullRequests()
    }
    
    private func binded(view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = {[weak self] viewModel in
            guard let self = self else { return }
            if viewModel.isLoading {
                self.view.beginRefreshing()
            } else {
                self.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}


