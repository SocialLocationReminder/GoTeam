//
//  FirstViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/24/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MBProgressHUD


class TasksViewController: UIViewController {

    // outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    // tasks and filtered tasks
    var tasks : [Task]?
    var filteredTasks : [Task]?

    // application layer 
    let taskManager = TaskManager()
    let labelManager = LabelManager.sharedInstance

    // MARK: - view load related
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        tableView.dataSource = self
        tableView.delegate = self

        // setup auto row height
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // setup search bar
        searchBar.delegate = self
        
        // fetch tasks
        fetchTasks()
        
        // setup add button view
        setupAddButton()
        
        setupTapGestureRecognizer()
        
        registerForUpdateNotificaiton()
    }
    
    func setupTapGestureRecognizer() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        //tapGR.delegate = self
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    @IBAction func hamburgerMenuTapped(_ sender: Any) {
        if let hamburgerVC = self.view.window?.rootViewController as? HamburgerViewController {
            searchBar.resignFirstResponder()
            hamburgerVC.toggleLeft()
            tableView.isUserInteractionEnabled = !tableView.isUserInteractionEnabled
        }
    }
    func registerForUpdateNotificaiton() {
        NotificationCenter.default.addObserver(self, selector: #selector(labelUpdated), name: Notification.Name(rawValue: Resources.Strings.Notifications.kLabelsUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdated), name: Notification.Name(rawValue: Resources.Strings.Notifications.kLocationsUpdated), object: nil)
    }

    func labelUpdated() {
        fetchTasks()
    }
    
    @objc func locationUpdated() {
        fetchTasks()
    }
    
    func didTapView(sender : UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func fetchTasks() {
        tasks = [Task]()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
        taskManager.allTasks(fetch: true, success: { (receivedTasks) in
            
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.tasks = receivedTasks
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                // @todo: show network error
                hud.hide(animated: true)
            }
        }
    }
    
    func setupAddButton() {
        
        addButton.layer.cornerRadius = 48.0 / 2.0
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 1.0;
        addButton.layer.shadowRadius = 2.0
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - unwind segues
    @IBAction func unwindToTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func doneUnwindToTasksViewControllerSegue(_ segue : UIStoryboardSegue) {

        
        let addTaskVC = segue.source as! AddTaskViewController
        
        let task = addTaskVC.task
        
        if let task = task {
            task.taskName = addTaskVC.textView.text
            task.taskNameWithAnnotations = task.taskName
            removeAnnotations(task: task)
            if addTaskVC.viewControllerState == .editMode {
                update(task: task)
            } else {
                add(task: task)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func removeAnnotations(task : Task) {
        var ranges = [Range<String.Index>]()
        if let taskDateSubrange = task.taskDateSubrange {
            ranges.append(taskDateSubrange)
        }
        if let taskFromDateSubrange = task.taskFromDateSubrange {
            ranges.append(taskFromDateSubrange)
        }
        if let taskLabelSubrange = task.taskLabelSubrange {
            ranges.append(taskLabelSubrange)
        }
        if let taskPrioritySubrange = task.taskPrioritySubrange {
            ranges.append(taskPrioritySubrange)
        }
        if let taskRecurrenceSubrange = task.taskRecurrenceSubrange {
            ranges.append(taskRecurrenceSubrange)
        }
        if let taskLocationSubrange = task.taskLocationSubrange {
            ranges.append(taskLocationSubrange)
        }
        if let taskContactsSubranges = task.taskContactsSubranges {
            for contactSubrange in taskContactsSubranges {
                ranges.append(contactSubrange)
            }
        }
        ranges.sort() { $0.upperBound > $1.upperBound }
        for range in ranges {
            task.taskName?.removeSubrange(range)
        }
    }

    func remove(prefix: TaskSpecialCharacter, textArray : [String],  text : String) -> String {
        var text = text
        let prefixStr = prefix.stringValue()
        for textToRemove in textArray {
            let strToRemove = prefixStr + textToRemove
            let range = text.range(of: strToRemove)
            if let range = range {
                text.removeSubrange(range)
            }
        }
        return text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Resources.Strings.TasksViewController.kShowEditTasksScreen ||
            segue.identifier == Resources.Strings.TasksViewController.kShowEditTasksScreenFromAnnotatedCell {
            let navVC = segue.destination as! UINavigationController
            let addTasksVC = navVC.topViewController as! AddTaskViewController

            if let cell = sender as? TaskCell {
                addTasksVC.task = cell.task
                // addTasksVC.task.taskNameWithAnnotations = cell.task?.taskNameWithAnnotations
                addTasksVC.viewControllerState = .editMode
            }
            if let cell = sender as? TaskWithAnnotationsCell {
                addTasksVC.task = cell.task
                // addTasksVC.task.taskNameWithAnnotations = cell.task?.taskNameWithAnnotations
                addTasksVC.viewControllerState = .editMode
            }
        }
    }

    // MARK: - task management
    func add(task : Task) {
        tasks?.append(task)
        taskManager.add(task: task)
        
        // if table is in a filtered state, then the filtered list
        // would need to be redone
        applyFilterPerSearchText()
    }

    func update(task : Task) {
        taskManager.update(task: task)

        // if table is in a filtered state, then the filtered list
        // would need to be redone
        applyFilterPerSearchText()
    }


    func remove(task : Task) {
        taskManager.delete(task: task)
        tasks = tasks?.filter() { $0 !== task }
        filteredTasks = filteredTasks?.filter() { $0 !== task }
    }
}


extension TasksViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let localTasks = tasksList()
        if localTasks![indexPath.row].taskPriority != nil ||
            localTasks![indexPath.row].taskRecurrence != nil ||
            localTasks![indexPath.row].taskLabel != nil ||
            localTasks![indexPath.row].taskLocation != nil ||
            localTasks![indexPath.row].taskContacts != nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Strings.TasksViewController.kTaskWithAnnotationsCell) as! TaskWithAnnotationsCell
            cell.task = localTasks![indexPath.row]
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Strings.TasksViewController.kTaskCell) as! TaskCell
        cell.task = localTasks![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList()?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension TasksViewController : UISearchBarDelegate {
    
    
    func tasksList() -> [Task]?
    {
        if let _ = filteredTasks {
            return filteredTasks;
        }

        return tasks
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        applyFilterPerSearchText()
    }
    
    func applyFilterPerSearchText() {
        guard var searchText = searchBar.text else { return; }
        searchText = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if searchText.characters.count == 0 {
            filteredTasks = nil;
            tableView.reloadData()
            return;
        }
        
        filteredTasks = [Task]();
        
        for task in tasks! {
            if( searchText[searchText.startIndex] == "#"){
                let startIndex = searchText.index(searchText.startIndex, offsetBy: 1)
                let searchLabel = searchText.substring(from: startIndex).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                if let label = task.taskLabel,
                    let labelName = label.labelName, 
                    labelName.contains(searchLabel) {
                        filteredTasks!.append(task);
                }
            }
            else if( searchText[searchText.startIndex] == TaskSpecialCharacter.priority.rawValue) {
                if let _ = task.taskPriority {
                    filteredTasks!.append(task);
                }
            }
            else if( searchText[searchText.startIndex] == TaskSpecialCharacter.contact.rawValue) {
                if let _ = task.taskContacts {
                    filteredTasks!.append(task);
                }
            }
            else if( searchText[searchText.startIndex] == TaskSpecialCharacter.location.rawValue) {
                if let _ = task.taskLocation {
                    filteredTasks!.append(task);
                }
            }
            else if( searchText.lowercased().contains((TaskSpecialCharacter.dueDate.stringValue() + Resources.Strings.TasksViewController.kTodayTasks).lowercased())) {
                if let taskDate = task.taskDate,
                    Calendar.current.isDateInToday(taskDate) {
                    filteredTasks!.append(task);
                }
            }
            else if( searchText.lowercased().contains((TaskSpecialCharacter.dueDate.stringValue() + Resources.Strings.TasksViewController.kTomorrowTasks).lowercased())) {
                if let taskDate = task.taskDate {
                    let today = Date()
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
                    if let tomorrow = tomorrow,
                        Calendar.current.isDate(tomorrow, inSameDayAs: taskDate) {
                        filteredTasks!.append(task);
                    }
                }
                
            }
            else if( searchText.lowercased().contains((TaskSpecialCharacter.dueDate.stringValue() + Resources.Strings.TasksViewController.kThisWeekTasks).replacingOccurrences(of: " ", with:"").lowercased())) {
                if let taskDate = task.taskDate {
                    let today = Date()
                    if Calendar.current.compare(taskDate, to: today, toGranularity: .weekOfYear) == .orderedSame {
                        filteredTasks!.append(task);
                    }
                }
            }

            else {
                if let taskName = task.taskName {
                    let taskNameRange = taskName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
                    if let taskNameRange = taskNameRange,
                        taskNameRange.isEmpty == false {
                        filteredTasks!.append(task);
                    }
                }
            }
        }
        if filteredTasks?.count != tasks?.count {
            tableView.reloadData()
        }
    }
}

extension TasksViewController : TaskCellDelegate, TaskWithAnnotationsCellDelegate {
    func deleteTaskCell(sender: TaskCell) {
        remove(task: sender.task!)
        tableView.reloadData()
    }
    
    func deleteTaskAnnotationsCell(sender: TaskWithAnnotationsCell) {
        remove(task: sender.task!)
        tableView.reloadData()
    }
    
}

