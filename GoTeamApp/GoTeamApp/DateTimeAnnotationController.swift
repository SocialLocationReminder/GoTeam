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
        
        // 1. preemptively enable the button
        button.isHighlighted = false
        button.isUserInteractionEnabled = true

        
        // 2. look for predefined patterns
        let foundPredefined = lookForPredefinedPatterns(specialChar: TaskSpecialCharacter.dueDate.stringValue())
        
        // 3. look for date and/or time patterns
        lookForDateTimePatterns(specialChar: TaskSpecialCharacter.dueDate.stringValue(),
                                    foundPredefined:foundPredefined)

        // 4. if button is still enabled that implies that no patterns were found nil out the dates
        if button.isUserInteractionEnabled == true {
            task.taskDate = nil
            task.taskDateSubrange = nil
        }
    }
    
    @discardableResult func lookForPredefinedPatterns(specialChar : String) -> Bool {
        for ix in 0..<dateArray.count {
            let testString = textView.text.contains(specialChar) ? (specialChar + dateArray[ix]) : dateArray[ix]
            if let range = textView.text.range(of: testString, options: .caseInsensitive, range: nil, locale: nil),
                !range.isEmpty {
                button.isHighlighted = true
                button.isUserInteractionEnabled = false
                
                let today = Date()
                task.taskDate = Calendar.current.date(byAdding: .day, value: ix, to: today)
                task.taskDateSubrange = range
                delegate?.attributeTextView(sender: self, pattern: testString, options: .caseInsensitive,
                                            fgColor: Resources.Colors.Annotations.kDateTimeFGColor,
                                            bgColor: Resources.Colors.Annotations.kDateTimeBGColor)
                return true
            }
        }
        return false
    }
    
    @discardableResult func lookForDateTimePatterns(specialChar : String, foundPredefined: Bool) -> Bool {
        
        let result = DateTimeUtil.findDateOrTimePattern(specialChar: specialChar, text: textView.text)
        
        // apply attributes if found
        if let range = result.rangeFound,
            let pattern = result.patternFound,
            let dateFormat = result.dateFormat,
            let dateFormatType = result.dateFormatType,
            !range.isEmpty {
            
            button.isHighlighted = true
            button.isUserInteractionEnabled = false
            
            var subRange = range
            if result.specialCharPresent == true {
                subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
            }
            
            let dateString = textView.text.substring(with: subRange).replacingOccurrences(of: " ", with: "", options: .caseInsensitive, range: nil)
            AddTaskViewController.dateFormatter.dateFormat = dateFormat
            if dateFormatType == .timeOnly {
                if let timePicked = AddTaskViewController.dateFormatter.date(from: dateString) {
                    var today = Date()
                    if foundPredefined, let taskDate = task.taskDate {
                        today = taskDate
                    }
                    let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
                    let todayComponents = gregorian.dateComponents(in: TimeZone.current, from: today)
                    let timePickedComponents = gregorian.dateComponents(in: TimeZone.current, from: timePicked)
                    let newComponents = DateComponents(calendar: gregorian, timeZone: .current, era: nil, year: todayComponents.year, month: todayComponents.month, day: todayComponents.day, hour: timePickedComponents.hour, minute: timePickedComponents.minute, second: timePickedComponents.second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
                    task.taskDate = gregorian.date(from: newComponents)
                }
            } else {
                task.taskDate = AddTaskViewController.dateFormatter.date(from: dateString)
            }
            task.timeSet = dateFormatType != .dateOnly
            
            var combinedRange = range
            if foundPredefined, let taskDateSubrange = task.taskDateSubrange {
                 combinedRange = Range<String.Index>(uncheckedBounds: (lower: taskDateSubrange.lowerBound, upper: range.upperBound))
            }
            task.taskDateSubrange = combinedRange
            delegate?.attributeTextView(sender: self, pattern: pattern, options: .regularExpression,
                                        fgColor: Resources.Colors.Annotations.kDateTimeFGColor,
                                        bgColor: Resources.Colors.Annotations.kDateTimeBGColor)
            return true
        }
        return false
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
        setButtonStateAndAnnotation()
        delegate?.hideTable(sender: self, annotationType: annotationType)
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
