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
    
    let queue = DispatchQueue(label: Resources.Strings.TaskDataStoreService.kTaskDataStoreServiceQueue)
    
    func add(task : Task) {
        
        let parseTask = PFObject(className:Task.kTaskClass)
        update(parseTask: parseTask, task: task)
    }
    
    func update(parseTask: PFObject, task: Task) {
        parseTask[User.kUserName] = User.kCurrentUser
        parseTask[Resources.Strings.Task.kTaskName] = task.taskName
        parseTask[Resources.Strings.Task.kTaskID] = task.taskID
        
        parseTask[Resources.Strings.Task.kTaskNameWithAnnotation] = task.taskNameWithAnnotations ?? NSNull()
        parseTask[Resources.Strings.Task.kTaskDate] = task.taskDate ?? NSNull()
        parseTask[Resources.Strings.Task.kTaskFromDate] = task.taskFromDate ?? NSNull()
        parseTask[Resources.Strings.Task.kTaskPriority] = task.taskPriority ?? NSNull()
        parseTask[Resources.Strings.Task.kTaskList] = NSNull()
        
        if let taskLabel = task.taskLabel {
            if let pfObject = LabelDataStoreService.parseObject(label: taskLabel) {
                parseTask[Resources.Strings.Task.kTaskList] = pfObject
            }
        }
        
        parseTask[Resources.Strings.Task.kTaskReccurence] = task.taskRecurrence ?? NSNull()
        
        parseTask[Resources.Strings.Task.kTaskRegion] = NSNull()
        if let taskRegion = task.taskRegion {
            if let pfObject = RegionDataStoreService.parseObject(region: taskRegion) {
                parseTask[Resources.Strings.Task.kTaskRegion] = pfObject
            }
        }
        
        parseTask[Task.kTaskLocation] =  NSNull()
        if let taskLocation = task.taskLocation {
            if let pfObject = LocationDataStoreService.parseObject(location: taskLocation) {
                parseTask[Resources.Strings.Task.kTaskLocation] =  pfObject
            }
        }
        
        if let taskContacts = task.taskContacts {
            var parseObjectsArray = [PFObject]()
            for contact in taskContacts {
                if let parseObject = ContactDataStoreService.pfObjectFor(contactID: contact.contactID!) {
                    parseObjectsArray.append(parseObject)
                }
            }
            if parseObjectsArray.count > 0 {
                parseTask[Task.kTaskContacts] = parseObjectsArray
            }
        } else {
            parseTask[Task.kTaskContacts] = NSNull()
        }
        
        if let timeSet = task.timeSet {
            parseTask[Task.kTaskTimeSet] = timeSet
        }
        
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
    func update(task : Task) {
        let query = PFQuery(className:Task.kTaskClass)
        query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
        query.whereKey(Task.kTaskID, equalTo: task.taskID!)
        //  query.includeKey(kTUserName)
        query.includeKey(Task.kTaskID)
        
        query.findObjectsInBackground(block: { (tasks, error) in
            if let tasks = tasks {
                let pfTask = tasks.first
                self.update(parseTask: pfTask!, task: task)
            }
        })
    }
    
    func delete(task : Task) {
        
        let query = PFQuery(className:Task.kTaskClass)
        query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
        query.whereKey(Task.kTaskID, equalTo: task.taskID!)
        //  query.includeKey(kTUserName)
        query.includeKey(Task.kTaskID)
        
        query.findObjectsInBackground(block: { (tasks, error) in
            if let tasks = tasks {
                tasks.first?.deleteEventually()
            }
        })
    }
    
    
    func allTasks(success:@escaping ([Task]) -> (), error: @escaping ((Error) -> ())) {
        
        let query = PFQuery(className:Task.kTaskClass)
        query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
        query.includeKey(User.kUserName)
        
        query.findObjectsInBackground(block: { (tasks, returnedError) in
            self.queue.async {
                if let tasks = tasks {
                    success(self.convertTotask(pfTasks: tasks))
                } else {
                    if let returnedError = returnedError {
                        error(returnedError)
                    } else {
                        error(NSError(domain: "failed to get tasks, unknown error", code: 0, userInfo: nil))
                    }
                }
            }
        })
    }
    
    func convertTotask(pfTasks : [PFObject]) -> [Task] {
        var tasks = [Task]()
        for pfTask in pfTasks {
            let task = Task()
            do {
                task.taskID = pfTask[Task.kTaskID] as? Date
                task.taskName = pfTask[Task.kTaskName] as? String
                task.taskNameWithAnnotations = pfTask[Task.kTaskNameWithAnnotation] as? String
                task.taskDate = pfTask[Task.kTaskDate] as? Date
                task.taskFromDate = pfTask[Task.kTaskFromDate] as? Date
                task.taskPriority = pfTask[Task.kTaskPriority] as? Int
                task.timeSet = pfTask[Task.kTaskTimeSet] as? Bool
                
                if let pfLocation = pfTask[Task.kTaskLocation]  as? PFObject {
                    try pfLocation.fetchIfNeeded()
                    task.taskLocation = LocationDataStoreService.location(pfLocation: pfLocation)
                }
                
                if let pfRegion = pfTask[Task.kTaskRegion]  as? PFObject {
                    try pfRegion.fetchIfNeeded()
                    task.taskRegion = RegionDataStoreService.region(pfRegion: pfRegion)
                }
                
                
                if let pfLabel = pfTask[Task.kTaskList] as? PFObject {
                    try pfLabel.fetchIfNeeded()
                    task.taskLabel = LabelDataStoreService.label(parseObject: pfLabel)
                }
                task.taskRecurrence = pfTask[Task.kTaskReccurence] as? Int
                if let parseObjectsArray = pfTask[Task.kTaskContacts] as? [PFObject] {
                    task.taskContacts = [Contact]()
                    for parseObject in parseObjectsArray {
                        task.taskContacts?.append(ContactDataStoreService.contact(pfObject: parseObject))
                    }
                }
            } catch _  {
                print("exception while attempting to convert pfobjects to tasks")
            }
            tasks.append(task)
        }
        return tasks
    }
}
