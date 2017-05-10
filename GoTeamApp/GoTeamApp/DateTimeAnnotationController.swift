//
//  DateTimeController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit



class DateTimeAnnotationController : AnnotationControllerProtocol {
    
    weak internal var delegate: AnnotationControllerDelegate?

    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 2
    var annotationType : AnnotationType!
    
    // data
    var dateArray = Resources.Strings.AnnotationController.kDateArray
    
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task) {
        
        self.textView = textView
        self.annotationType = annotationType
        self.task = task
        self.button = button
        
        setupGestureRecognizer()
    }
    
    func clearAnnotationInTask() {
        task.taskDateSubrange = nil
        task.taskDate = nil
    }
    
    func setupGestureRecognizer() {
        let today = Date()
        let dayAfter = Calendar.current.date(byAdding: .day, value: 2, to: today)
        AddTaskViewController.dateFormatter.dateFormat = "EEEE"
        dateArray[2] = AddTaskViewController.dateFormatter.string(from: dayAfter!)
        let dayAfterThat = Calendar.current.date(byAdding: .day, value: 3, to: today)
        dateArray[3] = AddTaskViewController.dateFormatter.string(from: dayAfterThat!)
        let nextDayAfterDayAfter = Calendar.current.date(byAdding: .day, value: 4, to: today)
        dateArray[4] = AddTaskViewController.dateFormatter.string(from: nextDayAfterDayAfter!)
        
        button.isHighlighted = false
        let buttonTapGR = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(buttonTapGR)
    }
    
    
    // MARK: - gesture recognizer 
    @objc func buttonTapped(sender : UITapGestureRecognizer) {
        delegate?.buttonTapped(sender: self, annotationType: annotationType)
    }

    
    // MARK: - button state
    func setButtonStateAndAnnotation() {
        button.isHighlighted = false
        button.isUserInteractionEnabled = true
        for ix in 0..<dateArray.count {
            let testString = TaskSpecialCharacter.dueDate.stringValue() + dateArray[ix]
            if textView.text.contains(testString) {
                button.isHighlighted = true
                button.isUserInteractionEnabled = false
                if task.taskDate == nil {
                    let today = Date()
                    task.taskDate = Calendar.current.date(byAdding: .day, value: ix, to: today)
                    task.taskDateSubrange = textView.text.range(of: testString)
                    delegate?.attributeTextView(sender: self, pattern: testString, options: .caseInsensitive,
                                                fgColor: Resources.Colors.Annotations.kDateTimeFGColor,
                                                bgColor: Resources.Colors.Annotations.kDateTimeBGColor)
                }
                
                break
            }
        }
        
        // date only pattern
        let pattern = "\\" + TaskSpecialCharacter.dueDate.stringValue() + Resources.Strings.AnnotationController.kDateRegExPattern
        let dateAndTimePattern = "\\" + TaskSpecialCharacter.dueDate.stringValue() + Resources.Strings.AnnotationController.kDateTimeRegExPattern
        // date and time pattern
        if let range = textView.text.range(of: dateAndTimePattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty {
            button.isHighlighted = true
            button.isUserInteractionEnabled = false
            if task.taskDate == nil {
                let subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
                let dateString = textView.text.substring(with: subRange)
                AddTaskViewController.dateFormatter.dateFormat = "dd MMM yyyy 'at' hh:mm a"
                task.taskDate = AddTaskViewController.dateFormatter.date(from: dateString)
                task.timeSet = true
                task.taskDateSubrange = range
                delegate?.attributeTextView(sender: self, pattern: dateAndTimePattern, options: .regularExpression,
                                            fgColor: Resources.Colors.Annotations.kDateTimeFGColor,
                                            bgColor: Resources.Colors.Annotations.kDateTimeBGColor)
                
            }
        } else if let range = textView.text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty {
            button.isHighlighted = true
            button.isUserInteractionEnabled = false
            if task.taskDate == nil {
                let subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
                let dateString = textView.text.substring(with: subRange)
                AddTaskViewController.dateFormatter.dateFormat = "dd MMM yyyy"
                task.taskDate = AddTaskViewController.dateFormatter.date(from: dateString)
                task.taskDateSubrange = range
                delegate?.attributeTextView(sender: self, pattern: pattern, options: .regularExpression,
                                            fgColor: Resources.Colors.Annotations.kDateTimeFGColor,
                                            bgColor: Resources.Colors.Annotations.kDateTimeBGColor)
            }
        }
        
        if button.isUserInteractionEnabled == true {
            task.taskDate = nil
            task.taskDateSubrange = nil
        }
    }
    
    // MARK: - Table View data source related
    func numberOfSections() -> Int {
        return DateTimeAnnotationController.kNumberOfSections
    }
    
    func numberOfRows(section: Int) -> Int {
        if section == 0 {
            return dateArray.count
        }
        return 1
    }

    func populate(cell : AddTaskCell, indexPath : IndexPath)  {

        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = indexPath.section == 0 ? dateArray[indexPath.row] : Resources.Strings.AddTasks.kPickADate
        if indexPath.section == 0 {
            let today = Date()
            let labelDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: today)
            AddTaskViewController.dateFormatter.dateFormat = "MMM d"
            cell.secondaryTextLabel.text = AddTaskViewController.dateFormatter.string(from: labelDate!)
            cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kCalendarIcon)
        } else {
            cell.addkTaskImageViewLeadingConstraint.constant = -10.0
        }
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        
        if indexPath.section == 1 {
            delegate?.perform(sender: self, segue: Resources.Strings.DateTimeAnnotationController.kShowCalendarSegue)
            return;
        }
        
        if indexPath.row == dateArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskDate = nil
        } else {
            delegate?.appendToTextView(sender: self, string: dateArray[indexPath.row])
        }
    }
    
    // MARK: - unwind segue from CalendarViewController
    func unwind(segue : UIStoryboardSegue) {
        if let calendarVC = segue.source as? CalendarViewController {
            
            let dateSelected = calendarVC.dateSelected ?? Date()
            AddTaskViewController.dateFormatter.dateFormat = "dd MMM yyyy"
            let dateSelectedStr = AddTaskViewController.dateFormatter.string(from: dateSelected)
            delegate?.appendToTextView(sender: self, string: dateSelectedStr)
            if calendarVC.timePicked == true {
                AddTaskViewController.dateFormatter.dateFormat = "hh:mm a"
                let timeSelectedStr = AddTaskViewController.dateFormatter.string(from: dateSelected)
                delegate?.appendToTextView(sender: self, string: Resources.Strings.AddTasks.kDateAndTimeSeparatorString)
                delegate?.appendToTextView(sender: self, string: timeSelectedStr)
            }
            delegate?.appendToTextView(sender: self, string: " ")
            setButtonStateAndAnnotation()
            textView.becomeFirstResponder()
        }
    }

}
