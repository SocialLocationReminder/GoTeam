//
//  TaskManager.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class TaskManager {
    
    var tasks = [Task]()
    let dataStoreService : TaskDataStoreServiceProtocol = TaskDataStoreService()

    let queue = DispatchQueue(label: Resources.Strings.TaskManager.kTaskManagerQueue)
    
    func add(task : Task) {
        queue.async {
            self.tasks.append(task)
            TaskManager.addNotificationsIfDatePresent(task: task)
            self.dataStoreService.add(task: task)
        }
    }

    func update(task : Task) {
        queue.async {
            TaskManager.updateNotificationsIfDatePresent(task: task)
            self.dataStoreService.update(task: task)
        }
    }

    
    func delete(task : Task) {
        queue.async {
            self.tasks = self.tasks.filter() { $0 !== task }
            self.dataStoreService.delete(task: task)
        }
    }

    func allTasks(fetch: Bool, success:@escaping (([Task]) -> ()), error: @escaping (Error) -> ()) {
        queue.async {
            if fetch == false {
                success(self.tasks)
            } else {
                self.dataStoreService.allTasks(success: { (tasks) in
                    self.tasks = tasks
                    success(tasks)
                    }, error: error)
            }
        }
    }
    
    // MARK: - static helpers
    internal static func addNotificationsIfDatePresent(task : Task) {
        
        if let taskFromDate = task.taskFromDate {
            if let dateMinusTen = offset(minutes: -10, from: taskFromDate),
                let taskName = task.taskName {
                let localNotificaiton = UILocalNotification()
                localNotificaiton.fireDate = dateMinusTen
                localNotificaiton.userInfo
                        = [
                            Resources.Strings.Task.kTaskID : "\(task.taskID!.timeIntervalSince1970)",
                            Resources.Strings.Task.kTaskFromDate : "\(taskFromDate.timeIntervalSince1970)"]
                localNotificaiton.alertBody = "\(taskName) \(Resources.Strings.AddTasks.kFromDateAlert)"
            }
        }
        
        if let taskDueDate = task.taskDate {
            if let dateMinusTen = offset(minutes: -10, from: taskDueDate),
                let taskName = task.taskName {
                let localNotificaiton = UILocalNotification()
                localNotificaiton.fireDate = dateMinusTen
                localNotificaiton.userInfo
                    = [
                        Resources.Strings.Task.kTaskID : "\(task.taskID!.timeIntervalSince1970)",
                        Resources.Strings.Task.kTaskDate : "\(taskDueDate.timeIntervalSince1970)"]
                localNotificaiton.alertBody = "\(taskName) \(Resources.Strings.AddTasks.kDueDateAlert)"
            }
        }
    }
    
    internal static func cancelNotificationsIfDatePresent(task: Task) {
        
    }
    
    internal static func updateNotificationsIfDatePresent(task : Task) {
        cancelNotificationsIfDatePresent(task: task)
        addNotificationsIfDatePresent(task: task)
    }
    
    static func offset(minutes : Int , from : Date) -> Date? {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.minute = minutes
        let newDate = gregorian.date(byAdding: components, to: from)
        return newDate
    }
    
}
