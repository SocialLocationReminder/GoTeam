//
//  TaskCell.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

@objc protocol TaskCellDelegate {
    func deleteTaskCell(sender : TaskCell)
}


class TaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var topView: UIView!
    

    static let dateFormatter = DateFormatter()

    @IBOutlet weak var cellFGViewLeadingSpaceConstraint: NSLayoutConstraint!
    weak var delegate : TaskCellDelegate?
    
    var tableCellUtil : TableCellUtil!
    
    var task : Task? {
        didSet {
            cellFGViewLeadingSpaceConstraint.constant = 0
            if let task = task {
                self.taskName.text = task.taskName
                taskDate.text = ""
                taskTimeLabel.text = ""
                if let date = task.taskDate {
                    TaskCell.dateFormatter.dateFormat = "MMM d"
                    taskDate.text = TaskCell.dateFormatter.string(from: date)
                    if let timeSet = task.timeSet,
                        timeSet == true {
                        TaskCell.dateFormatter.dateFormat = "hh:mm a"
                        taskTimeLabel.text = TaskCell.dateFormatter.string(from: date)
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGR = UIPanGestureRecognizer(target: self, action: #selector(topViewPanned))
        self.topView.addGestureRecognizer(tapGR)
        tableCellUtil = TableCellUtil(contentView: contentView, viewLeadingConstraint: cellFGViewLeadingSpaceConstraint)
    }
    
    func topViewPanned(sender : UIPanGestureRecognizer) {
        tableCellUtil.handleDeletePan(sender: sender, deleteActionComplete: { 
                self.delegate?.deleteTaskCell(sender: self)
            }, deleteActionInComplete: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
