//
//  GroupManager.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class GroupManager {

    var groups = [Group]()
    let dataStoreService : CirclesDataStoreServiceProtocol = CirclesDataStoreService()
    
    let queue = DispatchQueue(label: Resources.Strings.GroupManager.kGroupManagerQueue)
    
    static let sharedInstance = GroupManager()
    
    func add(group : Group, success:@escaping () -> (), error: @escaping ((Error) -> ())) {
        queue.async {
            self.dataStoreService.add(group: group, success: success, error: error)
        }
    }
    
    func allGroups(fetch: Bool, success:@escaping (([Group]) -> ()), error: @escaping (Error) -> ()) {
        queue.async {
            if fetch == false {
                success(self.groups)
            } else {
                self.dataStoreService.allCircles(success: success, error: error)
            }
        }
    }

}
