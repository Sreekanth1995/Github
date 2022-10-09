//
//  PullReqCellController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullReqCellController {
    private let model: PullRequest
    private var cell: PullReqCell?
    init(model: PullRequest) {
        self.model = model
    }
    
    func view(in tableView: UITableView) -> PullReqCell {
        cell = tableView.dequeReusableCell()
        return cell!
    }
    
    func display() {
        cell?.titleLabel.text = model.title
        cell?.closedAtLabel.text = model.closedAt
        cell?.createdAtLabel.text = model.createdAt
        cell?.userNameLabel.text = "Test"
    }
}
