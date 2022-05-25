//
//  RepositoriesTableViewCell.swift
//  GithubRepository
//
//  Created by Naveen Natrajan on 25/05/22.
//

import UIKit

class RepositoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryOwnerName: UILabel!
    @IBOutlet weak var avatarImageVIew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
