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
    
  init(placemark: MKPlacemark) {
    title = placemark.name
    if let locality = placemark.locality,
      let administrativeArea = placemark.administrativeArea {
      subtitle = "\(locality), \(administrativeArea)"
    }
    latitude = placemark.coordinate.latitude
    longitude = placemark.coordinate.longitude
  }
  
  var title: String?
  var subtitle: String?
  var latitude: Double
  var longitude: Double
  
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

