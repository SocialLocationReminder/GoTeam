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
    case priority
}

class AddTaskViewController: UIViewController {

    
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


    
    func priorityButtonTapped(sender : UITapGestureRecognizer) {
        let text = textView.text
        let textArray = Array(text!.characters)

        if textArray[textArray.count - 1] != " " {
            textView.text = textView.text + " "
        }
        textView.text = textView.text + "!"
        tableView.isHidden = false
        maskView.isHidden = true
        tableState = .priority
        tableView.reloadData()
    }
}

extension AddTaskViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableState {
        case .priority:
            return priorityArray.count
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
    }
    
    
}
