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
    
    static let priorityTextArray = ["High", "Medium", "Low"]

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNameTrailingImageView: UIImageView!
    
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
                taskTimeLabel.text = ""
                if let date = task.taskDate {
                    TaskCell.dateFormatter.dateFormat = "MMM d"
                    taskDateLabel.text = TaskCell.dateFormatter.string(from: date)
                    
                    if let timeSet = task.timeSet,
                        timeSet == true {
                        TaskCell.dateFormatter.dateFormat = "hh:mm a"
                        taskTimeLabel.text = TaskCell.dateFormatter.string(from: date)
                    }
                }
                
                // set defaults
                firstAnnotationLabel.isHidden = true
                secondAnnotationLabel.isHidden = true
                thirdAnnotationLabel.isHidden = true
                fourthAnnotationLabel.isHidden = true
                taskNameTrailingImageView.isHidden = true
                firstAnnotationImage.image = nil
                secondAnnotationImage.image = nil
                thirdAnnotationImage.image = nil
                fourthAnnotationImage.image = nil
                taskNameTrailingImageView.image = nil
                
                if let priority = task.taskPriority {
                    setAnnotation(text: TaskWithAnnotationsCell.priorityTextArray[priority - 1], image: UIImage(named: Resources.Images.Tasks.kExclamation))
                }
                
                if let label = task.taskLabel {
                    setAnnotation(text: label, image: UIImage(named: Resources.Images.Tasks.kListIcon))
                }
                
                if let location = task.taskLocation {
                    setAnnotation(text: location.title, image: UIImage(named: Resources.Images.Tasks.kLocationIcon))
                }
                
                if let contacts = task.taskContacts {
                    setAnnotation(text: contacts.first!.fullName, image: UIImage(named:Resources.Images.Tasks.kPawnIcon))
                }
                
                if let _ = task.taskRecurrence {
                    taskNameTrailingImageView.image = UIImage(named: Resources.Images.Tasks.kRecurringIcon)
                    taskNameTrailingImageView.isHidden = false
                }
            }
        }
    }
    
    func setAnnotation(text: String?, image : UIImage?) {
        if firstAnnotationLabel.isHidden {
            firstAnnotationLabel.text = text
            firstAnnotationLabel.isHidden = false
            firstAnnotationImage.image = image
            firstAnnotationImage.isHidden = false
        } else if secondAnnotationLabel.isHidden {
            secondAnnotationLabel.text = text
            secondAnnotationLabel.isHidden = false
            secondAnnotationImage.image = image
            secondAnnotationImage.isHidden = false
        } else if thirdAnnotationLabel.isHidden {
            thirdAnnotationLabel.text = text
            thirdAnnotationLabel.isHidden = false
            thirdAnnotationImage.image = image
            thirdAnnotationImage.isHidden = false
        } else if fourthAnnotationLabel.isHidden {
            fourthAnnotationLabel.text = text
            fourthAnnotationLabel.isHidden = false
            fourthAnnotationImage.image = image
            fourthAnnotationImage.isHidden = false
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
