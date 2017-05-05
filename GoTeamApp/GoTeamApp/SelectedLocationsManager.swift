//
//  SelectedLocationsManager.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

class SelectedLocationsManager {
  
  var locations = [Location]()
  let dataStoreService : DataStoreServiceProtocol = DataStoreService()
  
  let queue = DispatchQueue(label: "SelectedLocationsManagerQueue")
  
  func add(location : Location) {
    queue.async {
      self.locations.append(location)
      //self.dataStoreService.add(location: location)
    }
  }
  
  func delete(location: Location) {
    queue.async {
      self.locations = self.locations.filter() { $0 !== location }
      //self.dataStoreService.delete(location: location)
    }
  }
  
  func allLocations(fetch: Bool, success:@escaping (([Location]) -> ()), error: @escaping (Error) -> ()) {
    queue.async {
      if fetch == false {
        success(self.locations)
      } else {
        //self.dataStoreService.allLocations(success: success, error: error)
      }
    }
  }
}
