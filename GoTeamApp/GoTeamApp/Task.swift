//
//  Task.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Task : ListItem {
    
    var taskID : Date?
    var taskName : String?
    var taskDate : Date?
    
    var taskPriority : Int?
    var taskLabel : String?
    var taskSocialContact : String?
    var taskLocation : String?
    
    
    // sub ranges
    var taskPrioritySubrange : Range<String.Index>?
    var taskDateSubrange : Range<String.Index>?
    var taskLabelSubrange : Range<String.Index>?
    
    init() {
        taskID = Date()
    }
}
