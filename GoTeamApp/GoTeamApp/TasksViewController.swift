//
//  FirstViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/24/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    
    let kTaskCell = "TaskCell"
    
    var tasks : [Task]?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // setup auto row height
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tasks = [Task]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func unwindToTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func doneUnwindToTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        let task = Task()
        
        let addTaskVC = segue.source as! AddTaskViewController
        
        task.taskName = addTaskVC.textView.text
        
        tasks?.append(task)
        self.tableView.reloadData()
    }

}


extension TasksViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kTaskCell) as! TaskCell
        cell.task = tasks![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
}

