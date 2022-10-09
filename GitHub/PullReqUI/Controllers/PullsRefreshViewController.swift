//
//  PullsRefreshViewController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullsRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = binded(view: UIRefreshControl())
    let viewModel: PullRequestsViewModel
    
    init(viewModel: PullRequestsViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadPullRequests()
    }
    
    private func binded(view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = {[weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}


