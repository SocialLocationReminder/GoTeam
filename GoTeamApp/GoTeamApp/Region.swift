//
//  Region.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Region {
  init(locationName: String, coordinate: CLLocationCoordinate2D, radius: String, boundary: String) {
    self.identifier = "Region for: " + locationName
    self.locationName = locationName
    self.latitude = coordinate.latitude
    self.longitude = coordinate.longitude
    self.radius = Double(radius) ?? 0
    
    if boundary.contains("Entry") {
      self.notifyOnEntry = true
    } else {
      self.notifyOnEntry = false
    }
    if boundary.contains("Exit") {
      self.notifyOnExit = true
    } else {
      self.notifyOnExit = false
    }
  }
  
  var identifier: String
  var locationName: String
  var radius: Double
  var latitude: Double
  var longitude: Double
  var notifyOnEntry: Bool
  var notifyOnExit: Bool
  
  var description: String {
    get {
      var text = " \(String(Int(radius)))m"
      if notifyOnEntry {
        text += " on entry"
      }
      if notifyOnExit {
        text += " on exit"
      }
      return text
    }
  }
  
  var coordinate: CLLocationCoordinate2D {
    get {
      return CLLocationCoordinate2DMake(latitude, longitude)
    }
    set {
      latitude = newValue.latitude
      longitude = newValue.longitude
    }
  }
}
