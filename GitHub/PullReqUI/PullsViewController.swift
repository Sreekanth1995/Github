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

    var pulls = [PullReqViewModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
    }
    
    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PullReqCell", for: indexPath) as! PullReqCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
