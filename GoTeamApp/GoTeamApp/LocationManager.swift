//
//  LocationManager.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/10/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MapKit

class LocationManager: NSObject {
  
   static let sharedInstance = CLLocationManager()
  
  override init() {
    super.init()
    LocationManager.sharedInstance.desiredAccuracy = kCLLocationAccuracyBest
    LocationManager.sharedInstance.requestAlwaysAuthorization()
  }
}
