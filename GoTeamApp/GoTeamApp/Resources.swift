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
        
        class AnnotationController {
            static let kDateRegExPattern =  "\\d{1,2}\\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s+\\d{4}"
            static let kDateTimeRegExPattern = "\\d{1,2}\\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s+\\d{4}"
            
            static let kRecurrenceArray = ["Every day", "Every week", "Every month", "Every year", "After a day", "After a week", "After a month", "After a year", "No repeat"]
            static let kDateArray = ["Today", "Tomorrow", "", "", "", "1 week", "No due date"]
        }
        
        class Contacts {
            static let kAddTaskNavItem = "Add Task"
            static let kNavigationBarTitle = "Contacts"
        }
        
        
        class DataStoreService {
            static let kUnknownError = "Unknown Error"
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
