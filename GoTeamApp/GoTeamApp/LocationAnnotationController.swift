//
//  LocationAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class LocationAnnotationController : AnnotationControllerProtocol {
    

    weak internal var delegate: AnnotationControllerDelegate?
    
    var tableFilter : String?
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 1
    var annotationType : AnnotationType!
    
    // application layer
    let locationManager = SelectedLocationsManager.sharedInstance
    
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
       // self.locationsMsg = Resources.Strings.AddTasks.kLoadingLocations
        fetchLocations()

    }
    
    
    // MARK: - gesture recognizer
    @objc func buttonTapped(sender : UITapGestureRecognizer) {
        delegate?.buttonTapped(sender: self, annotationType: annotationType)
    }
    
    
    // MARK: - button state
    func setButtonState() {
        button.isHighlighted = false
        button.isUserInteractionEnabled = true
        for ix in 0..<locations().count {
            let location = locations()[ix]
            let testString = TaskSpecialCharacter.location.stringValue() + location.title!
            if textView.text.contains(testString) {
                button.isHighlighted = true
                button.isUserInteractionEnabled = false
                if task.taskLocation == nil {
                    
                    task.taskLocation = location
                    task.taskLabelSubrange = textView.text.range(of: testString)
                    delegate?.attributeTextView(sender: self, pattern: testString, options: .caseInsensitive,
                                                fgColor: Resources.Colors.Annotations.kLocationFGColor,
                                                bgColor: Resources.Colors.Annotations.kLocationBGColor)
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
        return LocationAnnotationController.kNumberOfSections
    }
    
    func numberOfRows(section: Int) -> Int {
        return locations().count
    }
    
    func populate(cell : AddTaskCell, indexPath : IndexPath)  {
        cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kLocationIcon)
        cell.primayTextLabel.text = locations()[indexPath.row].title
        cell.secondaryTextLabel.text = ""
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        if let locationName = locations()[indexPath.row].title {
            delegate?.appendToTextView(sender: self, string: locationName)
            delegate?.appendToTextView(sender: self, string: " ")
            setButtonState()
        }
    }
    
    // MARK: - fetch and filter locations
    func locations() -> [Location] {
        if let tableFilter = tableFilter {
            
            if tableFilter.characters.count == 0 {
                return locationManager.locations;
            }
            
            var filteredLocations = [Location]();
            
            for location in locationManager.locations {
                
                if let locationName = location.title {
                    
                    let locationRange = locationName.range(of: tableFilter, options: .caseInsensitive, range: nil, locale: nil)
                    
                    if locationRange?.isEmpty == false {
                        filteredLocations.append(location);
                    }
                }
            }
            return filteredLocations
        }
        return locationManager.locations
    }
    
    func fetchLocations() {
        locationManager.allLocations(fetch: true, success: { (locations) in
                self.delegate?.reloadTable(sender: self, annotationType: self.annotationType)

        }) { (error) in
            // self.locationsMsg = Resources.Strings.AddTasks.kFailedLoadingLabels
        }
    }

    
}
