//
//  TasksTableViewController.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MBProgressHUD

class TasksTableViewController: UITableViewController {
    
    @IBOutlet var tasksTableView: UITableView!
    // tasks and filtered tasks
    var tasks : [Task]?
    var filteredTasks : [Task]?
    
    // application layer
    let taskManager = TaskManager()
    let labelManager = LabelManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
//        tableView.register(UINib(nibName: "TaskWithAnnotationsCell", bundle: nil), forCellReuseIdentifier: "TaskWithAnnotationsCell")
        tableView.dataSource = self
        tableView.delegate = self

//        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
//        tableView.register(TaskWithAnnotationsCell.self, forCellReuseIdentifier: "TaskWithAnnotationsCell")

        // fetch tasks
        fetchTasks()
    }

    func fetchTasks() {
        tasks = [Task]()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
        taskManager.allTasks(fetch: true, success: { (receivedTasks) in
            
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.tasks = receivedTasks
                self.refreshUI()
            }
        }) { (error) in
            DispatchQueue.main.async {
                // @todo: show network error
                hud.hide(animated: true)
            }
        }
    }
    
    func refreshUI() {
        self.tasksTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (tasksList()?.count)! > 0{
            return 1
        }
        
        return (tasksList()?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 2){ // my dynamic cell is index 2
            return 5 // just for testing, add here yourrealdata.count
        }
        return 1 // for static content return 1
    }

    func tasksList() -> [Task]?
    {
        if let _ = filteredTasks {
            return filteredTasks;
        }
        return tasks
    }
}
