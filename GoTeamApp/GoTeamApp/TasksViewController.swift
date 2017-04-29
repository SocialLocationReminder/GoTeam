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

    
    let kTaskCell = "TaskCell"
    let kTaskWithAnnotationsCell = "TaskWithAnnotationsCell"
    
    var tasks : [Task]?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!

    let taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // setup auto row height
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        // setup add button view
        setupAddButton()
    }
    
    func setupAddButton() {
        
        addButton.layer.cornerRadius = 48.0 / 2.0
        addButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        self.tableView.setEditing(true, animated: true)
        self.tableView.setNeedsDisplay()
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func unwindToTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func doneUnwindToTasksViewControllerSegue(_ segue : UIStoryboardSegue) {

        
        let addTaskVC = segue.source as! AddTaskViewController
        
        let task = addTaskVC.task
        
        if let task = task {
            task.taskName = remove(prefix : "^", textArray: addTaskVC.dateArray, text: addTaskVC.textView.text)
            task.taskName = remove(prefix : "!", textArray: ["1", "2", "3"], text: task.taskName!)
            tasks?.append(task)
            self.taskManager.add(task: task)
        }
        
        self.tableView.reloadData()
    }
    



    func remove(prefix: String, textArray : [String],  text : String) -> String {
        var text = text
        for textToRemove in textArray {
            let strToRemove = prefix + textToRemove
            let range = text.range(of: strToRemove)
            if let range = range {
                text.removeSubrange(range)
            }
        }
        return text
    }
}


extension TasksViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tasks![indexPath.row].taskPriority != nil {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kTaskWithAnnotationsCell) as! TaskWithAnnotationsCell
            cell.task = tasks![indexPath.row]
            cell.delegate = self
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kTaskCell) as! TaskCell
        cell.task = tasks![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
}


extension TasksViewController : TaskCellDelegate, TaskWithAnnotationsCellDelegate {
    func deleteTaskCell(sender: TaskCell) {
        let indexPath = self.tableView.indexPath(for: sender)
        
        if let indexPath = indexPath {
            self.taskManager.delete(task: sender.task!)
            self.tasks?.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func deleteTaskAnnotationsCell(sender: TaskWithAnnotationsCell) {
        let indexPath = self.tableView.indexPath(for: sender)
        
        if let indexPath = indexPath {
            self.taskManager.delete(task: sender.task!)
            self.tasks?.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
}





