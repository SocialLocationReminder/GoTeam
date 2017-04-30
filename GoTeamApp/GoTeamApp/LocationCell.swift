//
//  LocationCell.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  var location: Location? {
    didSet{
      nameLabel.text = location?.title ?? ""
      locationLabel.text = location?.subtitle ?? ""
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
