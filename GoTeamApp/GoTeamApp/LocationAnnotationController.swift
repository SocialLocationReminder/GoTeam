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
  
    // user choices for region monitoring
    var regionLocation: Location?
    var regionRadius: String?
    var regionBoundary: String?
  
    // table state logic
    var tableState = TableState.showLocations
  
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
        let kGeoFencingMetersRegExPattern = Resources.Strings.RegEx.kGeoFencingMetersRegExPattern;
        let kGeoFencingEntryRegExPattern = Resources.Strings.RegEx.kGeoFencingEntryRegExPattern;
        let kGeoFencingExitRegExPattern = Resources.Strings.RegEx.kGeoFencingExitRegExPattern;
        for ix in 0..<locations().count {
            let location = locations()[ix]
            let locationString = TaskSpecialCharacter.location.stringValue() + location.title!
            
            let patterns = [locationString,
                            locationString + kGeoFencingMetersRegExPattern + kGeoFencingEntryRegExPattern,
                            locationString + kGeoFencingMetersRegExPattern + kGeoFencingExitRegExPattern]
            
            for pattern in patterns {
                if let range = textView.text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
                    !range.isEmpty {
                    button.isHighlighted = true
                    button.isUserInteractionEnabled = false
                    task.taskLocation = location
                    task.taskLocationSubrange = textView.text.range(of: locationString)
                    delegate?.attributeTextView(sender: self, pattern: pattern, options: .regularExpression,
                                                fgColor: Resources.Colors.Annotations.kLocationFGColor,
                                                bgColor: Resources.Colors.Annotations.kLocationBGColor)
                }
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
          return RegionManager.regionRadiuses.count
        case .showBoundaryCrossings :
          return RegionManager.boundaryCrossings.count
      }
    }
    
  func populate(cell : AddTaskCell, indexPath : IndexPath)  {
    switch(tableState)
    { case .showLocations :
      cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kLocationIcon)
      cell.primayTextLabel.text = locations()[indexPath.row].title
      cell.secondaryTextLabel.text = ""
    case .showRegionRadiuses :
      cell.primayTextLabel.text = RegionManager.regionRadiuses[indexPath.row]
    case .showBoundaryCrossings :
      cell.primayTextLabel.text = RegionManager.boundaryCrossings[indexPath.row]
    }
  }
  
  // MARK: - table view delegate related
  func didSelect(_ indexPath : IndexPath) {
    switch(tableState) {
    case .showLocations :
      regionLocation = locations()[indexPath.row]
      tableState = .showRegionRadiuses
      delegate?.reloadTable(sender: self, annotationType: .location)
    case .showRegionRadiuses :
      regionRadius = RegionManager.regionRadiuses[indexPath.row]
      tableState = .showBoundaryCrossings
      delegate?.reloadTable(sender: self, annotationType: .location)
    case .showBoundaryCrossings :
      regionBoundary = RegionManager.boundaryCrossings[indexPath.row]
      if let regionLocation = regionLocation,
        let locationName = regionLocation.title,
        let regionRadius = regionRadius,
        let regionBoundary = regionBoundary {
        let region = Region(locationName: locationName, coordinate: regionLocation.coordinate, radius: regionRadius, boundary: regionBoundary)
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
