//
//  TaskDataStoreService.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import Parse

class TaskDataStoreService : TaskDataStoreServiceProtocol {
    
    
    // user related
    let kTUserName = "UserName"
    var userName = "akshay"
    
    // task related
    let kTaskID   = "taskID"
    let kTaskName = "taskName"
    let kTaskDate = "taskDate"
    let kTaskPriority = "taskPriority"
    let kTaskReccurence = "taskReccurence"
    let kTaskList = "taskList"
    let kTaskSocialContact = "taskSocialContact"
    let kTaskLocation = "taskLocation"
    
    
    func add(task : Task) {
        
        let parseTask = PFObject(className:Task.kTaskClass)
        parseTask[kTUserName] = userName
        parseTask[kTaskName] = task.taskName
        parseTask[kTaskID] = task.taskID
        
        if let taskDate = task.taskDate {
            parseTask[kTaskDate] = taskDate
        }
        if let taskPriority = task.taskPriority {
            parseTask[kTaskPriority] = taskPriority
        }
        if let taskList = task.taskLabel {
            parseTask[kTaskList] = taskList
        }
        if let taskSocialContact = task.taskSocialContact {
            parseTask[kTaskSocialContact] = taskSocialContact
        }
        
        if let taskReccurence = task.taskRecurrence {
            parseTask[kTaskReccurence] = taskReccurence
        }
        
        if let taskLocation = task.taskLocation {
            parseTask[kTaskLocation] =  LocationDataStoreService.parseObject(location: taskLocation)
        }
        
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
    
    func delete(task : Task) {
        
        let query = PFQuery(className:Task.kTaskClass)
        query.whereKey(kTUserName, equalTo: userName)
        query.whereKey(kTaskID, equalTo: task.taskID!)
        //  query.includeKey(kTUserName)
        query.includeKey(kTaskID)
        
        query.findObjectsInBackground(block: { (tasks, error) in
            if let tasks = tasks {
                tasks.first?.deleteEventually()
            }
        })
    }
    
    
    func allTasks(success:@escaping ([Task]) -> (), error: @escaping ((Error) -> ())) {
        
        let query = PFQuery(className:Task.kTaskClass)
        query.whereKey(kTUserName, equalTo: userName)
        query.includeKey(userName)
        
        query.findObjectsInBackground(block: { (tasks, returnedError) in
            if let tasks = tasks {
                success(self.convertTotask(pfTasks: tasks))
            } else {
                if let returnedError = returnedError {
                    error(returnedError)
                } else {
                    error(NSError(domain: "failed to get tasks, unknown error", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    func convertTotask(pfTasks : [PFObject]) -> [Task] {
        var tasks = [Task]()
        for pfTask in pfTasks {
            let task = Task()
            do {
                task.taskID = pfTask[kTaskID] as? Date
                task.taskName = pfTask[kTaskName] as? String
                task.taskDate = pfTask[kTaskDate] as? Date
                task.taskPriority = pfTask[kTaskPriority] as? Int
                
                if let pfLocation = pfTask[kTaskLocation]  as? PFObject {
                    try pfLocation.fetchIfNeeded()
                    task.taskLocation = LocationDataStoreService.location(pfLocation: pfLocation)
                }
                
                task.taskLabel = pfTask[kTaskList] as? String
                task.taskRecurrence = pfTask[kTaskReccurence] as? Int
                task.taskSocialContact = pfTask[kTaskSocialContact] as? String
            } catch _  {
                print("exception while attempting to convert pfobjects to tasks")
            }
            tasks.append(task)
        }
        return tasks
    }
}
