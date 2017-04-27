//
//  TaskCell.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    
    static let dateFormatter = DateFormatter()
    
    var task : Task? {
        didSet {
            if let task = task {
                self.taskName.text = task.taskName
            
                if let date = task.taskDate {
                    TaskCell.dateFormatter.dateFormat = "MMM d"
                    taskDate.text = TaskCell.dateFormatter.string(from: date)
                }
            }
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
