//
//  Group.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

class Group : ListItem {
    var groupID : Date?
    var groupName : String?
    var contacts  : [Contact]?
    
    init() {
        groupID = Date()
    }
}
