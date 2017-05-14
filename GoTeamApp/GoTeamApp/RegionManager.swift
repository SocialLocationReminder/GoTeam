//
//  RegionManager.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation

class RegionManager : NSObject {
  
  static let sharedInstance = RegionManager()
  
  let locationManager = CLLocationManager()
  
  var regions = [Region]()
  //let dataStoreService : TaskDataStoreServiceProtocol = TaskDataStoreService()
  
  let queue = DispatchQueue(label: Resources.Strings.RegionManager.kRegionManagerQueue)
  
  func add(region : Region) {
    queue.async {
      self.regions.append(region)
      //self.addNotificationsIfDatePresent(task: task)
      //self.dataStoreService.add(task: task)
    }
  }
  
  func delete(region : Region) {
    queue.async {
      self.regions = self.regions.filter() { $0 !== region }
      //self.cancelNotificationsIfDatePresent(task: task)
      //self.dataStoreService.delete(task: task)
    }
  }
  
  func startMonitoring(region : Region) {
      let circularRegion = CLCircularRegion(center: region.coordinate, radius: region.radius, identifier: region.identifier)
      locationManager.startMonitoring(for: circularRegion)
  }
  
  //  func allTasks(fetch: Bool, success:@escaping (([Task]) -> ()), error: @escaping (Error) -> ()) {
  //    queue.async {
  //      if fetch == false {
  //        success(self.tasks)
  //      } else {
  //        self.dataStoreService.allTasks(success: { (tasks) in
  //          self.tasks = tasks
  //          success(tasks)
  //        }, error: error)
  //      }
  //    }
  //  }
  
  //  // MARK: - static helpers
  //  internal func addNotificationsIfDatePresent(task : Task) {
  //    if let date = task.taskFromDate {
  //      addNotifications(task: task, date: date, minutes: -10, message: Resources.Strings.AddTasks.kFromDateSoonAlert)
  //      addNotifications(task: task, date: date, minutes: 0, message: Resources.Strings.AddTasks.kFromDateAlert)
  //    }
  //    if let date = task.taskDate {
  //      addNotifications(task: task, date: date, minutes: -10, message: Resources.Strings.AddTasks.kDueDateSoonAlert)
  //      addNotifications(task: task, date: date, minutes: 0, message: Resources.Strings.AddTasks.kDueDateAlert)
  //    }
  //  }
  //
  //  internal func addNotifications(task : Task, date : Date, minutes : Int, message : String) {
  //    if task.timeSet == nil || task.timeSet! == false {
  //      return;
  //    }
  //
  //    if let fireDate = TaskManager.offset(minutes: minutes, from: date),
  //      let taskName = task.taskName,
  //      let taskID = task.taskID {
  //
  //      let center = UNUserNotificationCenter.current()
  //      center.requestAuthorization(options: [.alert, .sound], completionHandler: { (returnedBool, error) in
  //        if returnedBool == true && error == nil {
  //          let content = UNMutableNotificationContent()
  //          content.body = "\(taskName) \(message)"
  //          content.sound = UNNotificationSound.default()
  //          UNUserNotificationCenter.current().delegate = self
  //          let interval = fireDate.timeIntervalSince(Date())
  //          if interval > 0 {
  //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
  //            let request = UNNotificationRequest(identifier: taskID.description, content: content, trigger: trigger)
  //            center.add(request) { (error) in
  //              if error != nil {
  //                // @todo: show an error dialog
  //              }
  //            }
  //          }
  //        }
  //      })
  //    }
  //  }
  //
  //  internal func cancelNotificationsIfDatePresent(task: Task) {
  //    if let taskID = task.taskID {
  //      let center = UNUserNotificationCenter.current()
  //      center.requestAuthorization(options: [.alert, .sound], completionHandler: { (returnedBool, error) in
  //        center.removePendingNotificationRequests(withIdentifiers: [taskID.description])
  //      })
  //    }
  //
  //  }
  //
  //  internal func updateNotificationsIfDatePresent(task : Task) {
  //    cancelNotificationsIfDatePresent(task: task)
  //    addNotificationsIfDatePresent(task: task)
  //  }
  //
  //  static func offset(minutes : Int , from : Date) -> Date? {
  //    let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
  //    var components = DateComponents()
  //    components.minute = minutes
  //    let newDate = gregorian.date(byAdding: components, to: from)
  //    return newDate
  //  }
  //
  //}
  //
  //extension TaskManager : UNUserNotificationCenterDelegate {
  //  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
  //    // print("Tapped in notification")
  //  }
  //
  //  //This is key callback to present notification while the app is in foreground
  //  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
  //
  //    //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
  //    //to distinguish between notifications
  //    completionHandler( [.alert,.sound,.badge])
  //  }
}

