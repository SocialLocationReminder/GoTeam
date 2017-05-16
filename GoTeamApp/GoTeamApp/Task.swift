//
//  Task.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Task : NSObject {
    
    static let kTaskClass = "TasksClassV6"
    
    
    static let kTaskID   = "kTaskID"
    static let kTaskName = "kTaskName"
    static let kTaskNameWithAnnotation = "kTaskNameWithAnnotation"
    static let kTaskDate = "kTaskDate"
    static let kTaskFromDate = "kTaskFromDate"
    static let kTaskPriority = "kTaskPriority"
    static let kTaskReccurence = "kTaskReccurence"
    static let kTaskList = "kTaskList"
    static let kTaskContacts = "kTaskContacts"
    static let kTaskLocation = "kTaskLocation"
    static let kTaskRegion  = "kTaskRegion"
    static let kTaskTimeSet = "kTaskTimeSet"

    
    var taskID : Date?
    var taskName : String?
    var taskFromDate :Date?
    var taskDate : Date?
    var taskNameWithAnnotations : String?
    var timeSet : Bool?
    
    var taskRecurrence : Int?
    var taskPriority : Int?
    var taskLabel : String?
    var taskLocation : Location?
    var taskContacts : [Contact]?
    var taskRegion : Region?
    
    // sub ranges
    var taskPrioritySubrange : Range<String.Index>?
    var taskFromDateSubrange : Range<String.Index>?
    var taskDateSubrange : Range<String.Index>?
    var taskLabelSubrange : Range<String.Index>?
    var taskRecurrenceSubrange : Range<String.Index>?
    var taskLocationSubrange : Range<String.Index>?
    var taskContactsSubranges : [Range<String.Index>]?
    
    override init() {
        super.init()
        taskID = Date()
    }
}
