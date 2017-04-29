//
//  TaskWithAnnotationsCell.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

@objc protocol TaskWithAnnotationsCellDelegate {
    func deleteTaskAnnotationsCell(sender : TaskWithAnnotationsCell)
}


class TaskWithAnnotationsCell: UITableViewCell {
    
    let kExclamation = "exclamation.png"
    static let priorityTextArray = ["High", "Medium", "Low"]

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    
    @IBOutlet weak var firstAnnotationImage: UIImageView!
    @IBOutlet weak var secondAnnotationImage: UIImageView!
    @IBOutlet weak var thirdAnnotationImage: UIImageView!
    @IBOutlet weak var fourthAnnotationImage: UIImageView!
    
    
    @IBOutlet weak var firstAnnotationLabel: UILabel!
    @IBOutlet weak var secondAnnotationLabel: UILabel!
    @IBOutlet weak var thirdAnnotationLabel: UILabel!
    @IBOutlet weak var fourthAnnotationLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cellFGViewLeadingSpaceConstraint: NSLayoutConstraint!
    
    weak var delegate : TaskWithAnnotationsCellDelegate?
    var tableCellUtil : TableCellUtil!
    
    var task : Task? {
        didSet {
            cellFGViewLeadingSpaceConstraint.constant = 0            
            if let task = task {
                taskNameLabel.text = task.taskName
                taskDateLabel.text = ""
                if let date = task.taskDate {
                    TaskCell.dateFormatter.dateFormat = "MMM d"
                    taskDateLabel.text = TaskCell.dateFormatter.string(from: date)
                }
                
                if let priority = task.taskPriority {
                    firstAnnotationImage.image = UIImage(named: kExclamation)
                    firstAnnotationImage.isHidden = false
                    firstAnnotationLabel.text = TaskWithAnnotationsCell.priorityTextArray[priority - 1]
                    firstAnnotationLabel.isHidden = false
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
            self.delegate?.deleteTaskAnnotationsCell(sender: self)
            }, deleteActionInComplete: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
