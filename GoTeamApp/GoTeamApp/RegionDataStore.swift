//
//  RegionDataStore.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import Parse

class RegionDataStoreService : RegionDataStoreServiceProtocol {
  
  func add(region : Region) {
    let parseTask = PFObject(className:Region.kRegionsClass)
    parseTask[User.kUserName] = User.kCurrentUser
    parseTask[Region.kRegionID] = region.regionID
    parseTask[Region.kRegionName] = region.regionName
    parseTask[Region.kRegionLocationName] = region.regionLocationName
    parseTask[Region.kRegionRadius] = region.radius
    parseTask[Region.kRegionLatitude] = region.latitude
    parseTask[Region.kRegionLongitude] = region.longitude
    parseTask[Region.kRegionNotifyOnEntry] = region.notifyOnEntry
    parseTask[Region.kRegionNotifyOnExit] = region.notifyOnExit
    parseTask.saveInBackground { (success, error) in
      if success {
        print("saved successfully")
      } else {
        print(error)
      }
    }
  }
  
  func delete(region : Region) {
    let query = PFQuery(className:Region.kRegionsClass)
    query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
    query.whereKey(Region.kRegionID, equalTo: region.regionID)
    query.includeKey(Region.kRegionID)
    query.findObjectsInBackground(block: { (labels, error) in
      if let labels = labels {
        labels.first?.deleteEventually()
      }
    })
  }
  
  func allRegions(success:@escaping ([Region]) -> (), error: @escaping ((Error) -> ())) {
    let query = PFQuery(className:Region.kRegionsClass)
    query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
    query.includeKey(User.kUserName)
    query.findObjectsInBackground(block: { (regions, returnedError) in
      if let regions = regions {
        success(self.convertToRegions(pfRegions: regions))
      } else {
        if let returnedError = returnedError {
          error(returnedError)
        } else {
          error(NSError(domain: "failed to get regions, unknown error", code: 0, userInfo: nil))
        }
      }
    })
  }
  
    func convertToRegions(pfRegions : [PFObject]) -> [Region] {
        var regions = [Region]()
        for pfRegion in pfRegions {
            let region = RegionDataStoreService.region(pfRegion: pfRegion)
            regions.append(region)
        }
        return regions
    }
    
    static func region(pfRegion : PFObject) -> Region {
        let region = Region()
        region.regionID = pfRegion[Region.kRegionID] as! Date
        region.regionName = pfRegion[Region.kRegionName] as? String
        region.regionLocationName = pfRegion[Region.kRegionLocationName] as? String
        region.radius = pfRegion[Region.kRegionRadius] as? Double
        region.latitude = pfRegion[Region.kRegionLatitude] as? Double
        region.longitude = pfRegion[Region.kRegionLongitude] as? Double
        region.notifyOnEntry = pfRegion[Region.kRegionNotifyOnEntry] as? Bool
        region.notifyOnExit = pfRegion[Region.kRegionNotifyOnExit] as? Bool
        return region
    }
    
    static func parseObject(region : Region) -> PFObject? {
        
        let query = PFQuery(className:Region.kRegionsClass)
        query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
        query.whereKey(Region.kRegionID, equalTo: region.regionID)
        
        var objects : [PFObject]?
        do {
            objects = try query.findObjects()
        } catch _ {
            return nil
        }
        return objects?.first
    }}

