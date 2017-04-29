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
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var topView: UIView!
    

    static let dateFormatter = DateFormatter()

    @IBOutlet weak var cellFGViewLeadingSpaceConstraint: NSLayoutConstraint!
    var gestureStaringPoint : CGPoint!
    weak var delegate : TaskCellDelegate?
    
    var task : Task? {
        didSet {
            cellFGViewLeadingSpaceConstraint.constant = 0
            if let task = task {
                self.taskName.text = task.taskName
                taskDate.text = ""
                if let date = task.taskDate {
                    TaskCell.dateFormatter.dateFormat = "MMM d"
                    taskDate.text = TaskCell.dateFormatter.string(from: date)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGR = UIPanGestureRecognizer(target: self, action: #selector(topViewPanned))
        self.topView.addGestureRecognizer(tapGR)
    }
    
    func topViewPanned(sender : UIPanGestureRecognizer) {
        let point = sender.translation(in: self.contentView)
        let velocity = sender.velocity(in: self.contentView)
        print(point)
        print(velocity)
        
        if sender.state == .began {
            gestureStaringPoint = point
        } else if sender.state == .changed {
            cellFGViewLeadingSpaceConstraint.constant = point.x - gestureStaringPoint.x
        } else {
            if velocity.x > 0 && point.x > self.contentView.frame.width * 0.8 {
                self.delegate?.deleteTaskCell(sender: self)
                cellFGViewLeadingSpaceConstraint.constant = self.contentView.frame.width
            } else {
                if point.x < 0 {
                    cellFGViewLeadingSpaceConstraint.constant = 0
                } else {
                    // snap it back into place
                    DispatchQueue.main.async {
                        self.moveContentCellback()
                    }
                }
            }
        }
    }
    
    func moveContentCellback() {
        self.cellFGViewLeadingSpaceConstraint.constant = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.layoutIfNeeded()
        })
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
