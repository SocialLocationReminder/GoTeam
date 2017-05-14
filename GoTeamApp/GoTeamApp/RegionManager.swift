//
//  RegionManager.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation

class RegionManager : NSObject {
  
  static let sharedInstance = RegionManager()
  static let regionRadiuses = ["10","30","100"]
  static let boundaryCrossings = ["Notify on Entry", "Notify on Exit", "Notify on Entry & Exit"]
  
  let locationManager = CLLocationManager()
  
  var regions = [Region]()
  let dataStoreService : RegionDataStoreServiceProtocol = RegionDataStoreService()
  
  let queue = DispatchQueue(label: Resources.Strings.RegionManager.kRegionManagerQueue)
  
  func add(region : Region) {
    queue.async {
      self.regions.append(region)
      self.dataStoreService.add(region: region)
    }
  }
  
  func delete(region : Region) {
    queue.async {
      self.regions = self.regions.filter() { $0 !== region }
      self.dataStoreService.delete(region: region)
    }
  }
  
  func startMonitoring(region : Region) {
      let circularRegion = CLCircularRegion(center: region.coordinate, radius: region.radius!, identifier: region.regionName!)
      locationManager.startMonitoring(for: circularRegion)
  }
  
    func allRegions(fetch: Bool, success:@escaping (([Region]) -> ()), error: @escaping (Error) -> ()) {
      queue.async {
        if fetch == false {
          success(self.regions)
        } else {
          self.dataStoreService.allRegions(success: { (regions) in
            self.regions = regions
            success(regions)
          }, error: error)
        }
      }
    }
}

