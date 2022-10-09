//
//  PullReqUIComposer.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit


final class PullReqUIComposer {
    private init() { }
    
    public static func pullReqsCompose(with loader: PullRequestsLoader, imageLoader: UserImageDataLoader) -> PullsViewController {
        let viewModel = PullRequestViewModel(loader: MainQueueDispatchDecorator(loader))
        let refreshViewController = PullsRefreshViewController(viewModel: viewModel)
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: PullsViewController.self))
        let viewController = storyBoard.instantiateInitialViewController() as! PullsViewController
        viewController.refreshController = refreshViewController
        viewModel.onPullReqsLoad = adaptPullRequestToCellControllers(viewController: viewController, loader: imageLoader)
        return viewController
    }
    
    private static func adaptPullRequestToCellControllers(viewController: PullsViewController, loader: UserImageDataLoader) -> (([PullRequest]) -> Void) {
        return {[weak viewController] items in
            viewController?.tableModels = items.map { model in
                let viewModel = UserImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init)
                return PullReqCellController(viewModel: viewModel)
            }
        }
    }
}
