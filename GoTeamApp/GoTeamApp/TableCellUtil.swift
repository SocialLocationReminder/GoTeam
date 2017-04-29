//
//  TableCellUtils.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class TableCellUtil {
    
    typealias CompletionHandlerClosureType = ()->()
    
    var contentView : UIView!
    var gestureStaringPoint : CGPoint!
    weak var cellFGViewLeadingSpaceConstraint: NSLayoutConstraint!
    
    init(contentView : UIView, viewLeadingConstraint: NSLayoutConstraint) {
        self.contentView = contentView
        self.cellFGViewLeadingSpaceConstraint = viewLeadingConstraint
    }
    
    func handleDeletePan(sender : UIPanGestureRecognizer,
                         deleteActionComplete: CompletionHandlerClosureType?,
                         deleteActionInComplete: CompletionHandlerClosureType?) {
        
        let point = sender.translation(in: self.contentView)
        let velocity = sender.velocity(in: self.contentView)
        
        if sender.state == .began {
            gestureStaringPoint = point
        } else if sender.state == .changed {
            if point.x < 0 {
                cellFGViewLeadingSpaceConstraint.constant = 0
            } else {
                cellFGViewLeadingSpaceConstraint.constant = point.x - gestureStaringPoint.x
            }
        } else {
            if velocity.x > 0 && point.x > self.contentView.frame.width * 0.25 {
                moveContentCellToRight(completionHandler: deleteActionComplete)
            } else {
                if point.x < 0 {
                    cellFGViewLeadingSpaceConstraint.constant = 0
                } else {
                    // snap it back into place
                    moveContentCellback(completionHandler: deleteActionInComplete)
                }
            }
        }
    }
    
    func moveContentCellToRight(completionHandler: CompletionHandlerClosureType?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                self.cellFGViewLeadingSpaceConstraint.constant = self.contentView.frame.width
                self.contentView.layoutIfNeeded()
                }, completion: { (someBool) in
                    completionHandler?()
            })
        }
    }
    
    func moveContentCellback(completionHandler: CompletionHandlerClosureType?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                self.cellFGViewLeadingSpaceConstraint.constant = 0
                self.contentView.layoutIfNeeded()
                }, completion: { (someBool) in
                    completionHandler?()
            })
        }
    }
}
