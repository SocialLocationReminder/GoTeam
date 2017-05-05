//
//  AddTaskCell.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/27/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class AddTaskCell: UITableViewCell {

    
    @IBOutlet weak var addTaskImageView: UIImageView!
    @IBOutlet weak var primayTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var addkTaskImageViewLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        primayTextLabel.text = ""
        secondaryTextLabel.text = ""
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
