//
//  Task.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Task {
    
    var taskID : Date?
    var taskName : String?
    var taskDate : Date?
    
    var taskPriority : Int?
    var taskList : String?
    var taskSocialContact : String?
    var taskLocation : String?
    
    
    init() {
        taskID = Date()
    }
}
