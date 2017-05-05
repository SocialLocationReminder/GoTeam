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
    let kTUserName = "UserName"
    var userName = "akshay"
    
    // location related
    let kLocationsClass = "LocationsClassV2"
    let kLocationID = "locationID"
    let kLocationTitle = "locationTitle"
    let kLocationSubtitle = "locationSubtitle"
    let kLocationLatitude = "locationLatitude"
    let kLocationLongitude = "locationLongitude"
    
    func add(location : Location) {
        
        let parseTask = PFObject(className:kLocationsClass)
        parseTask[kTUserName] = userName
        parseTask[kLocationID] = location.locationID
        parseTask[kLocationTitle] = location.title
        parseTask[kLocationSubtitle] = location.subtitle
        parseTask[kLocationLatitude] = location.latitude
        parseTask[kLocationLongitude] = location.longitude
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
    func delete(location : Location) {
        let query = PFQuery(className:kLocationsClass)
        query.whereKey(kTUserName, equalTo: userName)
        query.whereKey(kLocationID, equalTo: location.locationID!)
        query.includeKey(kLocationID)
        query.findObjectsInBackground(block: { (locations, error) in
            if let locations = locations {
                locations.first?.deleteEventually()
            }
        })
    }
    

    func allLocations(success:@escaping ([Location]) -> (), error: @escaping ((Error) -> ())) {
        let query = PFQuery(className:kLocationsClass)
        query.whereKey(kTUserName, equalTo: userName)
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
    

    func convertToLocations(pfLocations : [PFObject]) -> [Location] {
        var locations = [Location]()
        for pfLocation in pfLocations {
            let location = Location()
            location.locationID = pfLocation[kLocationID] as? Date
            location.title = pfLocation[kLocationTitle] as? String
            location.subtitle = pfLocation[kLocationSubtitle] as? String
            location.latitude = pfLocation[kLocationLatitude] as? Double
            location.longitude = pfLocation[kLocationLongitude] as? Double
            locations.append(location)
        }
        return locations
    }
}
