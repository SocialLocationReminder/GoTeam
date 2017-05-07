//
//  Location.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
  
  
  static let kLocationsClass = "LocationsClassV3"
  static let kLocationID = "locationID"
  static let kLocationTitle = "locationTitle"
  static let kLocationSubtitle = "locationSubtitle"
  static let kLocationLatitude = "locationLatitude"
  static let kLocationLongitude = "locationLongitude"
  
  
  override init() {
    super.init()
    locationID = String(describing: coordinate)
  }
  
  init(placemark: MKPlacemark) {
    super.init()
    locationID = String(describing: coordinate)
    title = placemark.name
    if let locality = placemark.locality,
      let administrativeArea = placemark.administrativeArea {
      subtitle = "\(locality), \(administrativeArea)"
    }
    latitude = placemark.coordinate.latitude
    longitude = placemark.coordinate.longitude
  }
  
  var locationID: String?
  var title: String?
  var subtitle: String?
  var latitude: Double?
  var longitude: Double?
  
  var coordinate: CLLocationCoordinate2D {
    get {
      if let latitude = latitude, let longitude = longitude {
        return CLLocationCoordinate2DMake(latitude, longitude)
      } else {
        return CLLocationCoordinate2DMake(0, 0)
      }
    }
    set {
      latitude = newValue.latitude
      longitude = newValue.longitude
    }
  }
}

