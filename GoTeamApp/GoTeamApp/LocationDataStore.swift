//
//  LocationDataStore.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import Parse


class LocationDataStoreService : LocationDataStoreServiceProtocol {
    
    let queue = DispatchQueue(label: Resources.Strings.LocationDataStoreService.kLocationDataStoreServiceQueue)
    
    // user related

    var userName = "akshay"
    
    func add(location : Location) {
        
        let parseTask = newParseObject(location: location)
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
    internal func newParseObject(location: Location) -> PFObject {
        let parseTask = PFObject(className:Location.kLocationsClass)
        parseTask[User.kUserName] = userName
        parseTask[Location.kLocationID] = location.locationID
        parseTask[Location.kLocationTitle] = location.title
        parseTask[Location.kLocationSubtitle] = location.subtitle
        parseTask[Location.kLocationLatitude] = location.latitude
        parseTask[Location.kLocationLongitude] = location.longitude
        return parseTask
    }
    
    func delete(location : Location) {
        let query = PFQuery(className:Location.kLocationsClass)
        query.whereKey(User.kUserName, equalTo: userName)
        query.whereKey(Location.kLocationID, equalTo: location.locationID!)
        query.includeKey(Location.kLocationID)
        query.findObjectsInBackground(block: { (locations, error) in
            if let locations = locations {
                locations.first?.deleteEventually()
            }
        })
    }

  func update(location : Location) {
    let query = PFQuery(className:Location.kLocationsClass)
    query.whereKey(User.kUserName, equalTo: userName)
    query.whereKey(Location.kLocationID, equalTo: location.locationID!)
    query.includeKey(Location.kLocationID)
    query.findObjectsInBackground(block: { (locations, error) in
      if let locations = locations {
        let parseTask = locations.first
        parseTask?[Location.kLocationTitle] = location.title
        parseTask?[Location.kLocationSubtitle] = location.subtitle
        parseTask?.saveInBackground(block: { (success, error) in
          if success {
            print("update saved")
          } else {
            print(error)
          }
        })
      }
    })
  }

    func allLocations(success:@escaping ([Location]) -> (), error: @escaping ((Error) -> ())) {
        let query = PFQuery(className:Location.kLocationsClass)
        query.whereKey(User.kUserName, equalTo: userName)
        query.includeKey(userName)
        query.findObjectsInBackground(block: { (locations, returnedError) in
            self.queue.async {
                if let locations = locations {
                    success(self.convertToLocations(pfLocations: locations))
                } else {
                    if let returnedError = returnedError {
                        error(returnedError)
                    } else {
                        error(NSError(domain: "failed to get locations, unknown error", code: 0, userInfo: nil))
                    }
                }
            }
        })
    }
    
    static func location(pfLocation: PFObject) -> Location {
        let location = Location()
        location.locationID = pfLocation[Location.kLocationID] as? String
        location.title = pfLocation[Location.kLocationTitle] as? String
        location.subtitle = pfLocation[Location.kLocationSubtitle] as? String
        location.latitude = pfLocation[Location.kLocationLatitude] as? Double
        location.longitude = pfLocation[Location.kLocationLongitude] as? Double
        return location
    }
    
    func convertToLocations(pfLocations : [PFObject]) -> [Location] {
        var locations = [Location]()
        for pfLocation in pfLocations {
            let location = LocationDataStoreService.location(pfLocation: pfLocation)
            locations.append(location)
        }
        return locations
    }
    
    // MARK: - static routines
    static func parseObject(location : Location) -> PFObject? {
        
        let query = PFQuery(className:Location.kLocationsClass)
        query.whereKey(User.kUserName, equalTo: "akshay")
        query.whereKey(Location.kLocationID, equalTo: location.locationID!)

        var objects : [PFObject]?
        do {
            objects = try query.findObjects()
        } catch _ {
            return nil
        }
        return objects?.first
    }
}
