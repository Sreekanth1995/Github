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
        let viewModel = PullRequestsViewModel(loader: MainQueueDispatchDecorator(loader))
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
                let viewModel = PullViewModel<UIImage>(model: model, imageLoader: loader, imageTransformer: { data in
                    let image = UIImage(data: data)
                    return image
                })
                return PullReqCellController(viewModel: viewModel)
            }
        }
    }
}
