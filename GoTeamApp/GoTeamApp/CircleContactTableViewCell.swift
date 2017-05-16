//
//  CircleContactTableViewCell.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/15/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class CircleContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
