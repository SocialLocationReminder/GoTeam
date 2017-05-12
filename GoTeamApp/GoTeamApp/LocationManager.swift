//
//  LocationManager.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/10/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
  
   static let sharedInstance = CLLocationManager()
  
  override init() {
    super.init()
    
    // Initialize Location Manager
    LocationManager.sharedInstance.delegate = self
    LocationManager.sharedInstance.requestLocation()
    LocationManager.sharedInstance.desiredAccuracy = kCLLocationAccuracyBest
    LocationManager.sharedInstance.requestAlwaysAuthorization()
  }
  
  // MARK: - Location Manager Delegate Methods
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      LocationManager.sharedInstance.requestLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Location Manager did update locations")
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error:: (error)")
  }
}
