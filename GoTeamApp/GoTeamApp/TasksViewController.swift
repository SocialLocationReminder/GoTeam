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
    
    
    
    // cells
    let kTaskCell = "TaskCell"
    let kTaskWithAnnotationsCell = "TaskWithAnnotationsCell"
    
    // tasks and filtered tasks
    var tasks : [Task]?
    var filteredTasks : [Task]?

    // application layer 
    let taskManager = TaskManager()
    
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
        addButton.clipsToBounds = true
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
            task.taskName = remove(prefix : .date, textArray: addTaskVC.dateArray, text: addTaskVC.textView.text)
            task.taskName = remove(prefix : .priority, textArray: ["1", "2", "3"], text: task.taskName!)
            task.taskName = removeDate(text: task.taskName!)
            add(task: task)
        }
        
        self.tableView.reloadData()
    }
    
    func removeDate(text : String) -> String {
        var text = text
        let pattern = "\\" + TaskSpecialCharacter.date.stringValue() + "\\d{1,2}\\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s+\\d{4}"
        if let range = text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty {
            text.removeSubrange(range)
            return text
        }
        return text
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
    
    // MARK: - task management
    func add(task : Task) {
        tasks?.append(task)
        taskManager.add(task: task)
        
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
        if localTasks![indexPath.row].taskPriority != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: kTaskWithAnnotationsCell) as! TaskWithAnnotationsCell
            cell.task = localTasks![indexPath.row]
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTaskCell) as! TaskCell
        cell.task = localTasks![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList()?.count ?? 0
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
            
            if let taskName = task.taskName {
                let taskNameRange = taskName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
                if let taskNameRange = taskNameRange,
                    taskNameRange.isEmpty == false {
                    filteredTasks!.append(task);
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





