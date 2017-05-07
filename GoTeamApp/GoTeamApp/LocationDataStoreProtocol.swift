//
//  LocationDataStoreProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


protocol LocationDataStoreServiceProtocol {
  
  func add(location: Location)
  func delete(location: Location)
  func update(location: Location)
  func allLocations(success:@escaping ([Location]) -> (), error: @escaping ((Error) -> ()));
}
