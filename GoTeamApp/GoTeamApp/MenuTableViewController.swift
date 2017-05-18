//
//  MenuTableViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/16/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    let kHomeSection = 0
    let kAllTasks      = 0
    let kTodayTasks    = 1
    let kTomorrowTasks = 2
    let kThisWeekTasks = 3
    
    let kFilterSection = 1
    let kPriorityFilter = 0
    let kLocationFilter = 1
    let kSharedFilter   = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func getTabBarController() -> UITabBarController? {
        
        if let hamburgerVC = self.view.window?.rootViewController as? HamburgerViewController {
            for controller in hamburgerVC.childViewControllers {
                if controller.isKind(of: UITabBarController.self) {
                    return controller as? UITabBarController
                }
            }
        }
        return nil;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tabBarController = getTabBarController(),
            let tasksNavVC = tabBarController.viewControllers?[0] as? UINavigationController,
            let tasksVC = tasksNavVC.topViewController as? TasksViewController {
                
            if indexPath.section == kHomeSection {
                switch indexPath.row {
                case kAllTasks:
                    tasksVC.searchBar.text = ""
                   // tasksVC.title = Resources.Strings.TasksViewController.kAllTasksTitle
                case kTodayTasks:
                    tasksVC.searchBar.text = TaskSpecialCharacter.dueDate.stringValue() +  Resources.Strings.TasksViewController.kTodayTasks
                   // tasksVC.title = Resources.Strings.TasksViewController.kTodayTasksTitle
                case kTomorrowTasks:
                    tasksVC.searchBar.text = TaskSpecialCharacter.dueDate.stringValue() +  Resources.Strings.TasksViewController.kTomorrowTasks
                   // tasksVC.title = Resources.Strings.TasksViewController.kTomorrowTasksTitle
                case kThisWeekTasks:
                    let str = TaskSpecialCharacter.dueDate.stringValue() +  Resources.Strings.TasksViewController.kThisWeekTasks
                    tasksVC.searchBar.text = str.replacingOccurrences(of: " ", with: "")
                   // tasksVC.title = Resources.Strings.TasksViewController.kThisWeekTasksTitle
                default:
                    break;
                }
            }
            if indexPath.section == kFilterSection {
                switch indexPath.row {
                case kLocationFilter:
                    tasksVC.searchBar.text = TaskSpecialCharacter.location.stringValue()
                    // tasksVC.title = Resources.Strings.TasksViewController.kLocationTasksTitle
                case kPriorityFilter:
                    tasksVC.searchBar.text = TaskSpecialCharacter.priority.stringValue()
                    // tasksVC.title = Resources.Strings.TasksViewController.kPriorityTasksTitle
                case kSharedFilter:
                    tasksVC.searchBar.text = TaskSpecialCharacter.contact.stringValue()
                    // tasksVC.title = Resources.Strings.TasksViewController.kSharedTasksTitle
                default:
                    break;
                }
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
            if let hamburgerVC = self.view.window?.rootViewController as? HamburgerViewController {
                tasksVC.applyFilterPerSearchText()
                tasksVC.tableView.isUserInteractionEnabled = true
                hamburgerVC.toggleLeft()
            }

        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
