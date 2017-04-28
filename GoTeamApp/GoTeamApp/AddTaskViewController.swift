//
//  AddTaskViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit


enum TableState {
    case none
    case date
    case dueDate
    case priority
}

class AddTaskViewController: UIViewController {

    static let dateFormatter = DateFormatter()
    
    let kAddTaskCell = "AddTaskCell"
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var dateButton: UIImageView!
    @IBOutlet weak var dueDateButton: UIImageView!
    @IBOutlet weak var priorityButton: UIImageView!
    @IBOutlet weak var listButton: UIImageView!
    @IBOutlet weak var repeatButton: UIImageView!
    @IBOutlet weak var locationButton: UIImageView!
    @IBOutlet weak var timeButton: UIImageView!
    @IBOutlet weak var contactButton: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableState : TableState = .none
    
    let priorityArray = ["1 - High", "2 - Medium", "3 - Low", "None"]
    var dateArray = ["Today", "Tomorrow", "", "", "", "1 week", "No due date"]
    
    var weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup text view
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.text = ""
        textView.accessibilityHint = "Enter Task Name"
        
        // setup mask view
        buttonView.isHidden = true
        
        
        // setup table view
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        // setup button
        setupPriorityButton()
        
        // setup due date
        setupDate()
    }
    
    func setupDate() {
        let today = Date()
        let dayAfter = Calendar.current.date(byAdding: .day, value: 2, to: today)
        AddTaskViewController.dateFormatter.dateFormat = "EEEE"
        dateArray[2] = AddTaskViewController.dateFormatter.string(from: dayAfter!)
        let dayAfterThat = Calendar.current.date(byAdding: .day, value: 3, to: today)
        dateArray[3] = AddTaskViewController.dateFormatter.string(from: dayAfterThat!)
        let nextDayAfterDayAfter = Calendar.current.date(byAdding: .day, value: 4, to: today)
        dateArray[4] = AddTaskViewController.dateFormatter.string(from: nextDayAfterDayAfter!)
        
        dateButton.isHighlighted = false
        let dateButtonTapGR = UITapGestureRecognizer(target: self, action: #selector(dateButtonTapped))
        dateButton.addGestureRecognizer(dateButtonTapGR)
    }

    func setupPriorityButton() {
        priorityButton.isHighlighted = false
        let priorityTapGR = UITapGestureRecognizer(target: self, action: #selector(priorityButtonTapped))
        priorityButton.addGestureRecognizer(priorityTapGR)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
    }

    func dateButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .date, char : "^")
    }

    
    func priorityButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .priority, char : "!")
    }
    
    func handleButtonTapped(state: TableState, char : String) {
        let text = textView.text
        let textArray = Array(text!.characters)
        
        if textArray[textArray.count - 1] != " " {
            textView.text = textView.text + " "
        }
        textView.text = textView.text + char
        tableView.isHidden = false
        maskView.isHidden = true
        tableState = state
        tableView.reloadData()
    }
}

extension AddTaskViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableState {
        case .priority:
            return 1
        case .date:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableState {
        case .priority:
            return priorityArray.count
        case .date:
            return dateArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableState {
        case .priority:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kAddTaskCell) as! AddTaskCell
            cell.textLabel?.text = priorityArray[indexPath.row]
            return cell
        case .date:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kAddTaskCell) as! AddTaskCell
            cell.textLabel?.text = dateArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableState {
        case .priority:
            
            if indexPath.row == priorityArray.count - 1  {
                let chars = Array(textView.text.characters)
                textView.text = String(chars[0..<chars.count - 2])
            } else {
                textView.text = textView.text + String(indexPath.row + 1)
                priorityButton.isUserInteractionEnabled = false
                priorityButton.isHighlighted = true
            }
        case .date:
            if indexPath.row == dateArray.count - 1  {
                let chars = Array(textView.text.characters)
                textView.text = String(chars[0..<chars.count - 2])
            } else {
                textView.text = textView.text + dateArray[indexPath.row]
                dateButton.isUserInteractionEnabled = false
                dateButton.isHighlighted = true
            }
        default: break
        }
        tableState = .none
        tableView.isHidden = true
        maskView.isHidden = false
    }
}

extension AddTaskViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text
        let textArray = Array(text!.characters)
        
        if textArray.count > 0 && self.buttonView.isHidden == true {
            self.buttonView.isHidden = false
            self.view.setNeedsDisplay()
        }
        
        
        if textView.text.contains("!1") == false &&
            textView.text.contains("!2") == false &&
            textView.text.contains("!3") == false {
            
            priorityButton.isHighlighted = false
            priorityButton.isUserInteractionEnabled = true
        } else {
            priorityButton.isHighlighted = true
            priorityButton.isUserInteractionEnabled = false
        }
        
        
        dateButton.isHighlighted = false
        dateButton.isUserInteractionEnabled = true
        for date in dateArray {
            let testString = "^" + date
            if textView.text.contains(testString) {
                dateButton.isHighlighted = true
                dateButton.isUserInteractionEnabled = false
                break
            }
        }
    }
    
    
}
