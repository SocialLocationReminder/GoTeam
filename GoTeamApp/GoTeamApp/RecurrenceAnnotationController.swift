//
//  RecurrenceAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class RecurrenceAnnotationController : AnnotationControllerProtocol {
    
    
    weak internal var delegate: AnnotationControllerDelegate?
    
    var tableFilter : String?
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 1
    var annotationType : AnnotationType!
    
    
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task) {
        
        self.textView = textView
        self.annotationType = annotationType
        self.task = task
        self.button = button
        
        setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        button.isUserInteractionEnabled = true
        button.isHighlighted = false
        let locationTapGR = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(locationTapGR)
    }
    
    
    // MARK: - gesture recognizer
    @objc func buttonTapped(sender : UITapGestureRecognizer) {
        delegate?.buttonTapped(sender: self, annotationType: annotationType)
    }
    
    
    // MARK: - button state
    func setButtonState() {
        button.isHighlighted = false
        button.isUserInteractionEnabled = true
        let recurrenceArray = Resources.Strings.AnnotationController.kRecurrenceArray
        for ix in 0..<recurrenceArray.count {
            let testString = TaskSpecialCharacter.recurrence.stringValue() + recurrenceArray[ix]
            if textView.text.contains(testString) {
                button.isHighlighted = true
                button.isUserInteractionEnabled = false
                if task.taskRecurrence == nil {
                    
                    // @todo: need to support multiple labels
                    task.taskRecurrence = ix
                    task.taskRecurrenceSubrange = textView.text.range(of: testString)
                    delegate?.attributeTextView(sender: self, pattern: testString, options: .caseInsensitive,
                                                fgColor: Resources.Colors.Annotations.kRecurrenceBGColor,
                                                bgColor: Resources.Colors.Annotations.kRecurrenceFGColor)
                }
                
                break
            }
        }
        
        if button.isUserInteractionEnabled == true {
            task.taskRecurrence = nil
            task.taskRecurrenceSubrange = nil
        }
    }
    
    // MARK: - Table View data source related
    func numberOfSections() -> Int {
        return PriorityAnnotationController.kNumberOfSections
    }
    
    func numberOfRows(section: Int) -> Int {
        return Resources.Strings.AnnotationController.kRecurrenceArray.count
    }
    
    func populate(cell : AddTaskCell, indexPath : IndexPath)  {
        cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kRecurringIcon)
        cell.primayTextLabel.text = Resources.Strings.AnnotationController.kRecurrenceArray[indexPath.row]
        cell.secondaryTextLabel.text = ""
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        let recurrenceArray = Resources.Strings.AnnotationController.kRecurrenceArray
        if indexPath.row == recurrenceArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskRecurrence = nil
        } else {
            delegate?.appendToTextView(sender: self, string: String(recurrenceArray[indexPath.row]))
            delegate?.appendToTextView(sender: self, string: " ")
            setButtonState()
        }
    }
    

}
