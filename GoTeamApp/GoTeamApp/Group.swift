//
//  Group.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

class Group : ListItem {
    static let kGroupClass = "GroupClassV1"
    static let kgroupID = "kgroupID"
    static let kgroupName  = "kgroupName"
    static let kcontactIDs = "kcontactIDs"
    
    var groupID : Date?
    var groupName : String?
    var contacts  : [Contact]?
    
    init() {
        groupID = Date()
    }
}
