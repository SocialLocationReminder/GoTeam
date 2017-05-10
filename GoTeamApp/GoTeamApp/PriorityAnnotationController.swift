//
//  PriorityAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class PriorityAnnotationController : AnnotationControllerProtocol {
    
    
    weak internal var delegate: AnnotationControllerDelegate?
    
    var tableFilter : String?
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 1
    var annotationType : AnnotationType!
    
    // data
    let priorityArray = ["1 - High", "2 - Medium", "3 - Low", "None"]
    let priorityValues = [1, 2, 3]
    

    
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
        
        button.isHighlighted = true
        button.isUserInteractionEnabled = false
        for priorityValue in priorityValues {
            let testString = TaskSpecialCharacter.priority.stringValue() + String(priorityValue)
            if textView.text.contains(testString) == false {
            
                button.isHighlighted = false
                button.isUserInteractionEnabled = true
                task.taskPriority = nil
                task.taskPrioritySubrange = nil
                // @todo: change the attribute color here for the "!"
            }
        }
        
        let pattern = "\\" + TaskSpecialCharacter.priority.stringValue() + buildPriorityValuesRegEx()
        
        if let range = textView.text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty, task.taskPriority == nil {
            let subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
            let priorityString = textView.text.substring(with: subRange)
            task.taskPriority = Int(priorityString)
            task.taskPrioritySubrange = range
            
            // attribute the text
            attributePriorityText()
        }
    }
    
    // MARK: - Table View data source related
    func numberOfSections() -> Int {
        return PriorityAnnotationController.kNumberOfSections
    }
    
    func numberOfRows(section: Int) -> Int {
        return priorityArray.count
    }
    
    func populate(cell : AddTaskCell, indexPath : IndexPath)  {
        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = priorityArray[indexPath.row]
        cell.secondaryTextLabel.text = ""
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        if indexPath.row == priorityArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskPriority = nil
        } else {
            delegate?.appendToTextView(sender: self, string: String(indexPath.row + 1))
            delegate?.appendToTextView(sender: self, string: " ")
            setButtonState()
        }
    }
    
    // MARK: attribute text
    func attributePriorityText() {
        
        let pattern = "\\" + TaskSpecialCharacter.priority.stringValue() + buildPriorityValuesRegEx()
        
        if let taskPriority = task.taskPriority {
            var bgColor = UIColor.white
            if taskPriority == 1 {
                bgColor = Resources.Colors.Annotations.kPriority1BGColor
            } else if taskPriority == 2 {
                bgColor = Resources.Colors.Annotations.kPriorrity2BGColor
            } else if taskPriority == 3 {
                bgColor = Resources.Colors.Annotations.kPriority3BGColor
            }
            delegate?.attributeTextView(sender: self, pattern: pattern, options: .regularExpression,
                                        fgColor: Resources.Colors.Annotations.kPriorityFGColor,
                                        bgColor: bgColor)
        }
    }
    
    func buildPriorityValuesRegEx() -> String {
        var output = ""
        for ix in 0..<priorityValues.count {
            if ix == 0 {
                output += "("
            }
            output += String(priorityValues[ix])
            if ix == priorityValues.count - 1 {
               output += ")"
            } else {
                output += "|"
            }
        }
        return output
    }
}
