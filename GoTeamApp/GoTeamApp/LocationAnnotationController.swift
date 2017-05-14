//
//  LocationAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum TableState {
  case showLocations
  case showRegionRadiuses
  case showBoundaryCrossings
}

class LocationAnnotationController : AnnotationControllerProtocol {
    

    weak internal var delegate: AnnotationControllerDelegate?
  
    let clLocationManager = CLLocationManager()
    
    var tableFilter : String?
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 1
    var annotationType : AnnotationType!
  
    // user choices
    var choosenLocation: Location?
    var choosenRadius: String?
    var choosenBoundary: String?
  
    // table state logic
    var tableState = TableState.showLocations
    let regionRadiuses = ["10","30","100"]
    let boundaryCrossings = ["Notify on Entry", "Notify on Exit", "Notify on Entry & Exit"]
  
    // application layer
    let locationManager = SelectedLocationsManager.sharedInstance
    
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task) {
        
        self.textView = textView
        self.annotationType = annotationType
        self.task = task
        self.button = button
        
        setupGestureRecognizer()
    }
    
    func clearAnnotationInTask() {
        task.taskLocationSubrange = nil
        task.taskLocation = nil
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
    func setButtonStateAndAnnotation() {
        button.isHighlighted = false
        button.isUserInteractionEnabled = true
        for ix in 0..<locations().count {
            let location = locations()[ix]
            let testString = TaskSpecialCharacter.location.stringValue() + location.title!
            if textView.text.contains(testString) {
                button.isHighlighted = true
                button.isUserInteractionEnabled = false
//                if let _ = task.taskLocation {
//                    break;
//                }
                
                task.taskLocation = location
                task.taskLocationSubrange = textView.text.range(of: testString)
                delegate?.attributeTextView(sender: self, pattern: testString, options: .caseInsensitive,
                                            fgColor: Resources.Colors.Annotations.kLocationFGColor,
                                            bgColor: Resources.Colors.Annotations.kLocationBGColor)
                
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
        switch(tableState)
        { case .showLocations :
            return LocationAnnotationController.kNumberOfSections
          case .showRegionRadiuses :
            return 1
          case .showBoundaryCrossings :
            return 1
        }
    }
    
    func numberOfRows(section: Int) -> Int {
      switch(tableState)
      { case .showLocations :
          return locations().count
        case .showRegionRadiuses :
          return regionRadiuses.count
        case .showBoundaryCrossings :
          return boundaryCrossings.count
      }
    }
    
  func populate(cell : AddTaskCell, indexPath : IndexPath)  {
    switch(tableState)
    { case .showLocations :
      cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kLocationIcon)
      cell.primayTextLabel.text = locations()[indexPath.row].title
      cell.secondaryTextLabel.text = ""
    case .showRegionRadiuses :
      cell.primayTextLabel.text = regionRadiuses[indexPath.row]
    case .showBoundaryCrossings :
      cell.primayTextLabel.text = boundaryCrossings[indexPath.row]
    }
  }
  
  // MARK: - table view delegate related
  func didSelect(_ indexPath : IndexPath) {
    switch(tableState) {
    case .showLocations :
      choosenLocation = locations()[indexPath.row]
      tableState = .showRegionRadiuses
      delegate?.reloadTable(sender: self, annotationType: .location)
    case .showRegionRadiuses :
      choosenRadius = regionRadiuses[indexPath.row]
      tableState = .showBoundaryCrossings
      delegate?.reloadTable(sender: self, annotationType: .location)
    case .showBoundaryCrossings :
      choosenBoundary = boundaryCrossings[indexPath.row]
      if let choosenLocation = choosenLocation,
        let locationName = choosenLocation.title,
        let choosenRadius = choosenRadius,
        let choosenBoundary = choosenBoundary {
        let region = Region(locationName: locationName, coordinate: choosenLocation.coordinate, radius: choosenRadius, boundary: choosenBoundary)
        RegionManager.sharedInstance.add(region: region)
        RegionManager.sharedInstance.startMonitoring(region: region)
        delegate?.appendToTextView(sender: self, string: region.description)
        delegate?.appendToTextView(sender: self, string: " ")
        setButtonStateAndAnnotation()
      }
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
                self.setButtonStateAndAnnotation()
                self.delegate?.reloadTable(sender: self, annotationType: self.annotationType)

        }) { (error) in
            // self.locationsMsg = Resources.Strings.AddTasks.kFailedLoadingLabels
        }
    }
}
