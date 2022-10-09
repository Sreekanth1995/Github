//
//  PullReqCell.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import UIKit

class PullReqCell: UITableViewCell {

    @IBOutlet weak var closedAtLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var repoNumberLabel: UILabel!
    @IBOutlet weak var stateIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
