//
//  PullReqCellController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullReqCellController {
    private let model: PullRequest
    
    init(model: PullRequest) {
        self.model = model
    }
    
    func view() -> PullReqCell {
        let cell = PullReqCell()
        cell.titleLabel.text = model.title
        cell.closedAtLabel.text = model.closedAt
        cell.createdAtLabel.text = model.createdAt
        cell.userNameLabel.text = "Test"
        return cell
    }
}
