//
//  ObjectStoreService.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import Parse

class DataStoreService : DataStoreServiceProtocol {
    
    
    let kTaskName = "taskName"
    let kTaskDate = "taskDate"
    let kTaskPriority = "taskPriority"
    let kTaskList = "taskList"
    let kTaskSocialContact = "taskSocialContact"
    let kTaskLocation = "taskLocation"
    
    func add(task : Task) {
        
        let parseTask = PFObject(className:"Tasks")
        parseTask["user"] = "akshay"
        parseTask[kTaskName] = task.taskName
        parseTask[kTaskDate] = task.taskDate
        parseTask[kTaskPriority] = task.taskPriority
        parseTask[kTaskList] = task.taskList
        parseTask[kTaskSocialContact] = task.taskSocialContact
        parseTask[kTaskLocation] = task.taskLocation
        
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
}
