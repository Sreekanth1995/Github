//
//  PullsController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullsViewController: UITableViewController {
    var refreshController: PullsRefreshViewController
    var tableModels = [PullReqCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(refreshController: PullsRefreshViewController) {
        self.refreshController = refreshController
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = refreshController.view
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
        let cellController = tableModels[indexPath.row]
        return cellController.view()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
