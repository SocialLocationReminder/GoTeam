//
//  RegionDataStoreProtocol.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


protocol RegionDataStoreServiceProtocol {
  
  func add(region: Region)
  func delete(region: Region)
  func allRegions(success:@escaping ([Region]) -> (), error: @escaping ((Error) -> ()));
}
