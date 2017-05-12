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
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("Monitoring status: Did Enter \(region.identifier)")
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    print("Monitoring status: Did Exit \(region.identifier)")
  }
  
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Monitoring failed for region with identifier: \(region!.identifier)")
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      LocationManager.sharedInstance.requestLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Location Manager did update locations")
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager failed with the following error: \(error)")
  }
}
