//
//  PullReqUIComposer.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullReqUIComposer {
    private init() { }
    
    public static func pullReqsCompose(with loader: PullRequestsLoader) -> PullsViewController {
        let viewModel = PullRequestViewModel(loader: loader)
        let refreshViewController = PullsRefreshViewController(viewModel: viewModel)
        let viewController = PullsViewController(refreshController: refreshViewController)
        viewModel.onPullReqsLoad = adaptPullRequestToCellControllers(viewController: viewController)
        return viewController
    }
    
    private static func adaptPullRequestToCellControllers(viewController: PullsViewController) -> (([PullRequest]) -> Void) {
        return {[weak viewController] items in
            viewController?.tableModels = items.map {
                return PullReqCellController(model: $0)
            }
        }
    }
}
