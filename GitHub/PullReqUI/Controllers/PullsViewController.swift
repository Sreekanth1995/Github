//
//  PullsController.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

final class PullsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    var refreshController: PullsRefreshViewController?
    var tableModels = [PullReqCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = refreshController?.viewModel.title
        tableView.prefetchDataSource = self
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = tableModels[indexPath.row]
        return cellController.view(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            tableModels[indexPath.row].preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
        
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        tableModels[indexPath.row].cancelLoad()
    }
}
