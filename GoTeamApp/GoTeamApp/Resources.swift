//
//  ResourcesStrings.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class Resources {

    class Images {
        class Tasks {
            static let kExclamation = "exclamation.png"
            static let kListIcon = "list_icon.png"
            static let kTagIcon = "labels.png"
            static let kRecurringIcon = "recurring_icon.png"
            static let kLocationIcon = "pin.png"
            static let kCalendarIcon = "calendar_icon.png"
            static let kAddIcon = "plus_icon.png"
            static let kPawnIcon = "pawn_icon.png"
        }
    }
    
    class Strings {
        class AddTasks {
            
            static let kAddTaskCell = "AddTaskCell"
            static let kPickADate   = "Pick a date and time"
            static let kNewList     = "Create a new label"

            static let kLoadingLabels = "Loading Labels..."
            static let kFailedLoadingLabels = "Loading Labels Failed"
            static let kLoadingLocations = "Loading Locations..."
            static let kFailedLoadingLocations = "Loading Locations Failed"
            static let kSelectContacts = "Select"
            static let kDateAndTimeSeparatorString = " at "
            
            static let kEditScreenTitle = "Edit Task"
            static let kAddScreenTitle  = "Add Task"
            
            static let kSpeechPrompt = "Say Something, I'm Listerning"
            
            static let kFromDateSoonAlert = "starts in 10 minutes"
            static let kFromDateAlert = "starts now"
            static let kDueDateSoonAlert = "is due in 10 minutes"
            static let kDueDateAlert = "is due now"
            static let kDateAlertIdentifier = "kDateAlertIdentifier"
        }
        
        class Task {
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
            static let kTaskRegion = "kTaskRegion"
            static let kTaskTimeSet = "kTaskTimeSet"
        }
        
        class Label {
            static let kEditLabelSegue = "editLabelSegue"
            static let kLabelTableViewCell = "LabelTableViewCell"
            
        }
        class TasksViewController {
            static let kTaskCell = "TaskCell"
            static let kTaskWithAnnotationsCell = "TaskWithAnnotationsCell"
            static let kShowEditTasksScreen = "showEditTasksScreen"
            static let kShowEditTasksScreenFromAnnotatedCell = "showEditTasksScreenFromAnnotatedCell"
            
        }
        
        class DateTimeAnnotationController {
            static let kUnwindCalendarSegue = "unwindDoneCalendarViewController"
            static let kShowCalendarSegue = "showCalendarSegue"
        }
        
        class RegEx {
            static let kDateRegExPattern =  "\\d{1,2}\\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s+\\d{4}"
            static let kFullTimeRegExPattern = "\\s*\\d{1,2}:\\d{2}\\s*(am|pm|AM|PM)"
            static let kHourOnlyTimeRegExPattern = "\\s*\\d{1,2}\\s*(am|pm|AM|PM)"
            static let kGeoFencingMetersRegExPattern = "\\s*\\d{2,3}\\s*m"
            static let kGeoFencingEntryRegExPattern  = "\\s*((On|on)\\s*(Entry|entry))"
            static let kGeoFencingExitRegExPattern   = "\\s*((On|on)\\s*(Exit|exit))"
            static let kGeoFencingEntryAndExitRegExPattern   = "\\s*((On|on)\\s*(Entry|entry)\\s*(&|and|And|AND)\\s*(Exit|exit))"
        }
        
        class AnnotationController {
            static let kRecurrenceArray = ["Every day", "Every week", "Every month", "Every year", "After a day", "After a week", "After a month", "After a year", "No repeat"]
            static let kDateArray = ["Today", "Tomorrow", "", "", "", "1 week", "No due date"]
        }
        
        class LocationAnnotationController {
            static let kChoiceNone = "None"
        }
        
        class Contacts {
            static let kAddTaskNavItem = "Add Contacts"
            static let kNavigationBarTitle = "Contacts"
        }
        
        class Groups {
            static let kNewCircleName = "new circle name"
            static let kCircle = "Circle"
            static let kCreate = "Create"
            static let kCircleTableViewCell = "CircleTableViewCell"
            static let kNewCircleUserMessage = "Enter circle name"
        }
        
        class DataStoreService {
            static let kUnknownError = "Unknown Error"
        }
        
        class TaskManager {
            static let kTaskManagerQueue = "kTaskManagerQueue"
        }

        class TaskDataStoreService {
            static let kTaskDataStoreServiceQueue = "kTaskDataStoreServiceQueue"
        }

        class CirclesDataStoreService {
            static let kCirclesDataStoreServiceQueue = "kCirclesDataStoreServiceQueue"
        }

        
        class LabelManager {
            static let kLabelManagerQueue = "kLabelManagerQueue"
        }

        class LabelDataStoreService {
            static let kLabelDataStoreServiceQueue = "kLabelDataStoreServiceQueue"
        }

        
        class RegionManager {
          static let kRegionManagerQueue = "kRegionManagerQueue"
        }
      
        class ContactManager {
            static let kContactManagerQueue = "kContactManagerQueue"
        }
        
        class GroupManager {
            static let kGroupManagerQueue = "kGroupManagerQueue"
        }
        
        class LocationDataStoreService {
            static let kLocationDataStoreServiceQueue = "kLocationDataStoreServiceQueue"
        }
        

    }
    
    class Colors {
        class Annotations {
            static let kDateTimeFGColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let kDateTimeBGColor  = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

            static let kPriorityFGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let kPriority1BGColor = UIColor.red
            static let kPriorrity2BGColor = UIColor.blue
            static let kPriority3BGColor = UIColor.orange

            static let kLabelFGColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let kLabelBGColor  = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            
            static let kContactFGColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let kContactBGColor  = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

            static let kLocationFGColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let kLocationBGColor  = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

            static let kRecurrenceFGColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let kRecurrenceBGColor  = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
}
