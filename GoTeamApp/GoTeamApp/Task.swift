//
//  Task.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Task : ListItem {
    
    static let kTaskClass = "TasksClassV4"
    
    var taskID : Date?
    var taskName : String?
    var taskDate : Date?
    var taskNameWithAnnotations : String?
    
    var taskRecurrence : Int?
    var taskPriority : Int?
    var taskLabel : String?
    var taskSocialContact : String?
    var taskLocation : Location?
    var taskContacts : [Contact]?
    
    // sub ranges
    var taskPrioritySubrange : Range<String.Index>?
    var taskDateSubrange : Range<String.Index>?
    var taskLabelSubrange : Range<String.Index>?
    var taskRecurrenceSubrange : Range<String.Index>?
    var taskLocationSubrange : Range<String.Index>?
    var taskContactsSubranges : [Range<String.Index>]?
    
    init() {
        taskID = Date()
    }
}
