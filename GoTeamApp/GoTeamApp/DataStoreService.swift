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
  
  
  // user related
  let kTUserName = "UserName"
  
  // task related
  let kTasksClass = "TasksClassV2"
  let kTaskID   = "taskID"
  let kTaskName = "taskName"
  let kTaskDate = "taskDate"
  let kTaskPriority = "taskPriority"
  let kTaskReccurence = "taskReccurence"
  let kTaskList = "taskList"
  let kTaskSocialContact = "taskSocialContact"
  let kTaskLocation = "taskLocation"
  
  // label related
  let kLabelsClass = "LabelsClassV2"
  let kLabelID   = "labelID"
  let kLabelName = "labelName"
  var userName = "akshay"
  
  // location related
  let kLocationsClass = "LocationsClassV2"
  let kLocationID = "locationID"
  let kLocationTitle = "locationTitle"
  let kLocationSubtitle = "locationSubtitle"
  let kLocationLatitude = "locationLatitude"
  let kLocationLongitude = "locationLongitude"
  
  func add(task : Task) {
    
    let parseTask = PFObject(className:kTasksClass)
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
    
    if let taskLocation = task.taskLocation {
      parseTask[kTaskLocation] = taskLocation
    }
    
    if let taskReccurence = task.taskRecurrence {
      parseTask[kTaskReccurence] = taskReccurence
    }
    
    parseTask.saveInBackground { (success, error) in
      if success {
        print("saved successfully")
      } else {
        print(error)
      }
    }
  }
  
  func add(label : Labels) {
    
    let parseTask = PFObject(className:kLabelsClass)
    parseTask[kTUserName] = userName
    parseTask[kLabelName] = label.labelName
    parseTask[kLabelID] = label.labelID
    parseTask.saveInBackground { (success, error) in
      if success {
        print("saved successfully")
      } else {
        print(error)
      }
    }
  }
  
  func add(location : Location) {
    
    let parseTask = PFObject(className:kLocationsClass)
    parseTask[kTUserName] = userName
    parseTask[kLocationID] = location.locationID
    parseTask[kLocationTitle] = location.title
    parseTask[kLocationSubtitle] = location.subtitle
    parseTask[kLocationLatitude] = location.latitude
    parseTask[kLocationLongitude] = location.longitude
    parseTask.saveInBackground { (success, error) in
      if success {
        print("saved successfully")
      } else {
        print(error)
      }
    }
  }
  
  func delete(task : Task) {
    
    let query = PFQuery(className:kTasksClass)
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
  
  func delete(label : Labels) {
    let query = PFQuery(className:kLabelsClass)
    query.whereKey(kTUserName, equalTo: userName)
    query.whereKey(kLabelID, equalTo: label.labelID!)
    query.includeKey(kLabelID)
    query.findObjectsInBackground(block: { (labels, error) in
      if let labels = labels {
        labels.first?.deleteEventually()
      }
    })
  }
  
  func delete(location : Location) {
    let query = PFQuery(className:kLocationsClass)
    query.whereKey(kTUserName, equalTo: userName)
    query.whereKey(kLocationID, equalTo: location.locationID!)
    query.includeKey(kLocationID)
    query.findObjectsInBackground(block: { (locations, error) in
      if let locations = locations {
        locations.first?.deleteEventually()
      }
    })
  }
  
  func allTasks(success:@escaping ([Task]) -> (), error: @escaping ((Error) -> ())) {
    
    let query = PFQuery(className:kTasksClass)
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
  
  func allLabels(success:@escaping ([Labels]) -> (), error: @escaping ((Error) -> ())) {
    let query = PFQuery(className:kLabelsClass)
    query.whereKey(kTUserName, equalTo: userName)
    query.includeKey(userName)
    query.findObjectsInBackground(block: { (labels, returnedError) in
      if let labels = labels {
        success(self.convertToLabels(pfLabels: labels))
      } else {
        if let returnedError = returnedError {
          error(returnedError)
        } else {
          error(NSError(domain: "failed to get labels, unknown error", code: 0, userInfo: nil))
        }
      }
    })
  }
  
  func allLocations(success:@escaping ([Location]) -> (), error: @escaping ((Error) -> ())) {
    let query = PFQuery(className:kLocationsClass)
    query.whereKey(kTUserName, equalTo: userName)
    query.includeKey(userName)
    query.findObjectsInBackground(block: { (locations, returnedError) in
      if let locations = locations {
        success(self.convertToLocations(pfLocations: locations))
      } else {
        if let returnedError = returnedError {
          error(returnedError)
        } else {
          error(NSError(domain: "failed to get locations, unknown error", code: 0, userInfo: nil))
        }
      }
    })
  }
  
  func convertTotask(pfTasks : [PFObject]) -> [Task] {
    var tasks = [Task]()
    for pfTask in pfTasks {
      let task = Task()
      task.taskID = pfTask[kTaskID] as? Date
      task.taskName = pfTask[kTaskName] as? String
      task.taskDate = pfTask[kTaskDate] as? Date
      task.taskPriority = pfTask[kTaskPriority] as? Int
      task.taskLocation = pfTask[kTaskLocation] as? String
      task.taskLabel = pfTask[kTaskList] as? String
      task.taskRecurrence = pfTask[kTaskReccurence] as? Int
      task.taskSocialContact = pfTask[kTaskSocialContact] as? String
      tasks.append(task)
    }
    return tasks
  }
  
  func convertToLabels(pfLabels : [PFObject]) -> [Labels] {
    var labels = [Labels]()
    for pfLabel in pfLabels {
      let label = Labels()
      label.labelID = pfLabel[kLabelID] as? Date
      label.labelName = pfLabel[kLabelName] as? String
      labels.append(label)
    }
    return labels
  }
  
  func convertToLocations(pfLocations : [PFObject]) -> [Location] {
    var locations = [Location]()
    for pfLocation in pfLocations {
      let location = Location()
      location.locationID = pfLocation[kLocationID] as? Date
      location.title = pfLocation[kLocationTitle] as? String
      location.subtitle = pfLocation[kLocationSubtitle] as? String
      location.latitude = pfLocation[kLocationLatitude] as? Double
      location.longitude = pfLocation[kLocationLongitude] as? Double
      locations.append(location)
    }
    return locations
  }
}
