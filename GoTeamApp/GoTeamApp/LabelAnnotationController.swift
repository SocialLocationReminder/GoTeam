//
//  LabelAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class LabelAnnotationController : AnnotationControllerProtocol {
    
    let kShowAddLabelScreen = "showAddLabelScreen"
    
    weak internal var delegate: AnnotationControllerDelegate?
    
    var tableFilter : String?
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 2
    var annotationType : AnnotationType!
    
    // application layer
    let labelManager = LabelManager.sharedInstance
    var labels : [Labels]?

    
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task) {
        
        self.textView = textView
        self.annotationType = annotationType
        self.task = task
        self.button = button
        
        setupGestureRecognizer()
    }
    
    func clearAnnotationInTask() {
        task.taskLabel = nil
        task.taskLabelSubrange = nil
    }
    
    func setupGestureRecognizer() {
        button.isUserInteractionEnabled = true
        button.isHighlighted = false
        let locationTapGR = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(locationTapGR)
        fetchLabels()
    }
    
    func fetchLabels() {
        labelManager.allLabels(fetch: true, success: { (labels) in
            self.labels = labels
            self.setButtonStateAndAnnotation()
            self.delegate?.reloadTable(sender: self, annotationType: self.annotationType)
        }) { (error) in
            
        }
    }

    
    
    // MARK: - gesture recognizer
    @objc func buttonTapped(sender : UITapGestureRecognizer) {
        delegate?.buttonTapped(sender: self, annotationType: annotationType)
    }
    
    
    // MARK: - button state
    func setButtonStateAndAnnotation() {
        guard let _ = labels else { return; }
        
        button.isHighlighted = false
        button.isUserInteractionEnabled = true
        for ix in 0..<labels!.count {
            if let labelName = labels![ix].labelName {
                let testString = TaskSpecialCharacter.label.stringValue() + labelName
                if textView.text.contains(testString) {
                    button.isHighlighted = true
                    button.isUserInteractionEnabled = false
//                    if let _ = task.taskLabel  {
//                        break;
//                    }
                    
                    // @todo: need to support multiple labels
                    task.taskLabel = labelName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    task.taskLabelSubrange = textView.text.range(of: testString)
                    delegate?.attributeTextView(sender: self, pattern: testString, options: .caseInsensitive,
                                                fgColor: Resources.Colors.Annotations.kLabelFGColor,
                                                bgColor: Resources.Colors.Annotations.kLabelBGColor)
                    
                    
                    break
                }
            }
        }
        
        if button.isUserInteractionEnabled == true {
            task.taskLabel = nil
            task.taskLabelSubrange = nil
        }
    }
    
    // MARK: - Table View data source related
    func numberOfSections() -> Int {
        return LabelAnnotationController.kNumberOfSections
    }
    
    func numberOfRows(section: Int) -> Int {
        return section == 0 ? labels?.count ?? 0 : 1
    }
    
    func populate(cell : AddTaskCell, indexPath : IndexPath)  {
        
        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = ""
        
        if indexPath.section == 0 {
            if let labels = labels {
                cell.primayTextLabel.text = labels[indexPath.row].labelName
                cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kListIcon)
            }
            
            /* @todo: revisit
            else {
                cell.primayTextLabel.text = self.labelsMsg
                cell.addkTaskImageViewLeadingConstraint.constant = -10.0
            }
             */
        } else {
            cell.primayTextLabel.text = Resources.Strings.AddTasks.kNewList
            cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kAddIcon)
        }
        
        cell.secondaryTextLabel.text = ""
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        
        if indexPath.section == 1 {
            // show add label screen
            delegate?.perform(sender: self, segue: kShowAddLabelScreen)
            return;
        }
        
        if let labelName = labels![indexPath.row].labelName {
            delegate?.appendToTextView(sender: self, string: labelName)
            delegate?.appendToTextView(sender: self, string: " ")
            setButtonStateAndAnnotation()
        }

    }
    
    
}
