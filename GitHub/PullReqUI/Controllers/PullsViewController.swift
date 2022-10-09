//
//  PullsController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

struct PullReqViewModel {
    let repoName: String
    let stateIcon: String
    let userImage: String
    let title: String
    let createdAt: String
    let closedAt: String?
}


class PullsViewController: UITableViewController {
    
    var refreshController: PullsRefreshViewController
    var tableModels = [PullRequest]()
    
    init(loader: PullRequestsLoader) {
        self.refreshController = PullsRefreshViewController(loader: loader)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = refreshController.view
        refreshController.onRefresh = {[weak self] items in
            guard let self = self else { return }
            self.tableModels = items
            self.tableView.reloadData()
        }
        refreshController.refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PullReqCell", for: indexPath) as! PullReqCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
