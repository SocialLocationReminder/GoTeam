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
    
    
    // user related
    static let kTUserName = "UserName"
    var userName = "akshay"
    
    // location related
    static let kLocationsClass = "LocationsClassV2"
    static let kLocationID = "locationID"
    static let kLocationTitle = "locationTitle"
    static let kLocationSubtitle = "locationSubtitle"
    static let kLocationLatitude = "locationLatitude"
    static let kLocationLongitude = "locationLongitude"
    
    func add(location : Location) {
        
        let parseTask = LocationDataStoreService.parseObject(location: location)
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
    static func parseObject(location: Location) -> PFObject {
        let parseTask = PFObject(className:kLocationsClass)
        parseTask[kTUserName] = "akshay"
        parseTask[kLocationID] = location.locationID
        parseTask[kLocationTitle] = location.title
        parseTask[kLocationSubtitle] = location.subtitle
        parseTask[kLocationLatitude] = location.latitude
        parseTask[kLocationLongitude] = location.longitude
        return parseTask
    }
    
    func delete(location : Location) {
        let query = PFQuery(className:LocationDataStoreService.kLocationsClass)
        query.whereKey(LocationDataStoreService.kTUserName, equalTo: userName)
        query.whereKey(LocationDataStoreService.kLocationID, equalTo: location.locationID!)
        query.includeKey(LocationDataStoreService.kLocationID)
        query.findObjectsInBackground(block: { (locations, error) in
            if let locations = locations {
                locations.first?.deleteEventually()
            }
        })
    }
    

    func allLocations(success:@escaping ([Location]) -> (), error: @escaping ((Error) -> ())) {
        let query = PFQuery(className:LocationDataStoreService.kLocationsClass)
        query.whereKey(LocationDataStoreService.kTUserName, equalTo: userName)
        query.includeKey(userName)
        query.findObjectsInBackground(block: { (locations, returnedError) in
            if let locations = locations {
                success(self.convertToLocations(pfLocations: locations))
            } else {
                if let returnedError = returnedError {
                    error(returnedError)
                } else {
                    error(NSError(domain: "failed to get locations, unknown error", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    static func location(pfLocation: PFObject) -> Location {
        let location = Location()
        location.locationID = pfLocation[kLocationID] as? Date
        location.title = pfLocation[kLocationTitle] as? String
        location.subtitle = pfLocation[kLocationSubtitle] as? String
        location.latitude = pfLocation[kLocationLatitude] as? Double
        location.longitude = pfLocation[kLocationLongitude] as? Double
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
}
