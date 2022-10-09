//
//  PullReqCellController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullReqCellController {
    private var cell: PullReqCell?
    
    private let viewModel: UserImageViewModel<UIImage>

    init(viewModel: UserImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> PullReqCell {
        cell = binded(tableView.dequeReusableCell())
        return cell!
    }
    
    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
    
    private func binded(_ cell: PullReqCell) -> PullReqCell {
        cell.repoNumberLabel.text = viewModel.repoName
        cell.titleLabel.text = viewModel.title
        cell.stateIcon.image = UIImage(named: viewModel.stateIcon)
        cell.createdAtLabel.text = viewModel.createdAt
        cell.closedAtLabel.text = viewModel.closedAt
        cell.userNameLabel.text = viewModel.userName
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.userIconView.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.userIconView.image = UIImage(named: "userIcon")
        }
        return cell
    }
}
