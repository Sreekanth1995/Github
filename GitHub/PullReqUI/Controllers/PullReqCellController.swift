//
//  PullReqCellController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullReqCellController {
    private var cell: PullReqCell?
    
    private let viewModel: PullViewModel<UIImage>

    init(viewModel: PullViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> PullReqCell {
        cell = binded(tableView.dequeReusableCell())
        viewModel.loadImageData()
        return cell!
    }
    
    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        cell = nil
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
            if isLoading {
                cell?.userIconView.image = UIImage(named: "userIcon")
            }
        }
        return cell
    }
}
