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
  
  static let kRegionsClass = "RegionsClassV2"
  static let kRegionID = "regionID"
  static let kRegionName = "regionName"
  static let kRegionLocationName = "regionLocationName"
  static let kRegionRadius = "regionRadius"
  static let kRegionLatitude = "regionLatitude"
  static let kRegionLongitude = "regionLongitude"
  static let kRegionNotifyOnEntry = "regionNotifyOnEntry"
  static let kRegionNotifyOnExit = "regionNotifyOnExit"
  
  init() {
    self.regionID = Date()
  }
  
  init(locationName: String, coordinate: CLLocationCoordinate2D, radius: String, boundary: String) {
    
    self.regionID = Date()
    self.regionName = "" + locationName
    self.regionLocationName = locationName
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
  
  var regionID: Date
  var regionName: String?
  var regionLocationName: String?
  var radius: Double?
  var latitude: Double?
  var longitude: Double?
  var notifyOnEntry: Bool?
  var notifyOnExit: Bool?
  
  var description: String {
    get {
      var text = regionLocationName!
      text += "\(String(Int(radius!)))m"
      if notifyOnEntry! {
        text += "OnEntry"
      }
      if notifyOnExit! {
        text += "OnExit"
      }
      return text
    }
  }
  
  var coordinate: CLLocationCoordinate2D {
    get {
      return CLLocationCoordinate2DMake(latitude!, longitude!)
    }
    set {
      latitude = newValue.latitude
      longitude = newValue.longitude
    }
  }
}
