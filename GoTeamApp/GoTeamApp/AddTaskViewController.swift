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
    case fromDate
    case dueDate
    case priority
    case label
}

class AddTaskViewController: UIViewController {

    static let dateFormatter = DateFormatter()
    
    let kShowCalendarSegue = "showCalendarSegue"
    let kShowAddLabelScreen = "showAddLabelScreen"
    
    let kAddTaskCell = "AddTaskCell"
    let kPickADate   = "Pick a date"
    let kNewList     = "Create a new label"
    let kCalendarIcon = "calendar_icon.png"
    let kListIcon = "list_icon.png"
    let kAddIcon = "plus_icon.png"
    
    let kPrioritySpecialCharacter : Character = "!"
    let kDateSpecialCharacter : Character = "^"
    
    let kPriorityHigh = "!1"
    let kPriorityMedium = "!2"
    let kPriorityLow = "!3"
    
    var LoadingLabelsMsg = "Loading Labels..."
    let kLoadingLocations = "Loading Locations..."
    
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
    
    var task : Task!
    
    var tableState : TableState = .none
    
    var tableStateToCharacterMap : [TableState : TaskSpecialCharacter] =
        [
            TableState.priority : TaskSpecialCharacter.priority,
            TableState.label : TaskSpecialCharacter.label,
            TableState.dueDate : TaskSpecialCharacter.dueDate
        ]

    // constructed by swapping the keys and values of the above map
    var specialCharacterToTableStateMap = [TaskSpecialCharacter : TableState]()

    
    let priorityArray = ["1 - High", "2 - Medium", "3 - Low", "None"]
    var dateArray = ["Today", "Tomorrow", "", "", "", "1 week", "No due date"]

    // application layer
    let labelManager = LabelManager()
    
    var labels : [Labels]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup text view
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.text = ""
        textView.accessibilityHint = ""
        
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
        
        // new task
        task = Task()

        // fetch labels
        fetchLabels()
        
        tableStateToCharacterMap.forEach { (k, v) in
            specialCharacterToTableStateMap[v] = k
        }
    }
    func setupLabelButton() {
        listButton.isUserInteractionEnabled = true
        listButton.isHighlighted = false
        let listTapGR = UITapGestureRecognizer(target: self, action: #selector(labelButtonTapped))
        listButton.addGestureRecognizer(listTapGR)
        
        fetchLabels()
    }
    
    func fetchLabels() {
        labelManager.allLabels(fetch: true, success: { (labels) in
            self.labels = labels
            if self.tableState == .label {
                self.tableView.reloadData()
            }
            }) { (error) in
                if self.tableState == .label {
                    self.LoadingLabelsMsg = "Failed to load labels"
                    self.tableView.reloadData()
                }
        }
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
        handleButtonTapped(state: .dueDate, char : TaskSpecialCharacter.dueDate.rawValue)
    }

    
    func priorityButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .priority, char : TaskSpecialCharacter.priority.rawValue)
    }
    
    func labelButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .label, char : TaskSpecialCharacter.label.rawValue)
    }
    
    func handleButtonTapped(state: TableState, char : Character) {
        
        let text = textView.text
        let textArray = Array(text!.characters)

        
        if textArray.count == 0 || textArray[textArray.count - 1] != char {
            if textArray.count > 0 && textArray[textArray.count - 1] != " " {
                textView.text = textView.text + " "
            }
            textView.text = textView.text + String(char)
        }
        
        tableView.isHidden = false
        maskView.isHidden = true
        tableState = state
        tableView.reloadData()
    }
    
    @IBAction func unwindCancelToAddTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }

    @IBAction func unwindDoneAddTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        if let calendarVC = segue.source as? CalendarViewController {
            let dateSelected = calendarVC.dateSelected ?? Date()
            task.taskDate = dateSelected
            AddTaskViewController.dateFormatter.dateFormat = "dd MMM yyyy"
            textView.text = textView.text + AddTaskViewController.dateFormatter.string(from: dateSelected)
            dateButton.isUserInteractionEnabled = false
            dateButton.isHighlighted = true
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension AddTaskViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableState {
        case .priority:
            return 1
        case .dueDate:
            return 2
        case .label:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableState {
        case .priority:
            return priorityArray.count
        case .dueDate:
            return section == 0 ? dateArray.count : 1
        case .label:
            return section == 0 ? labels?.count ?? 1 : 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 30.0 : 0.0
    }
    
    
    func dateCell(indexPath : IndexPath) -> AddTaskCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = indexPath.section == 0 ? dateArray[indexPath.row] : kPickADate
        if indexPath.section == 0 {
            let today = Date()
            let labelDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: today)
            AddTaskViewController.dateFormatter.dateFormat = "MMM d"
            cell.secondaryTextLabel.text = AddTaskViewController.dateFormatter.string(from: labelDate!)
            cell.addTaskImageView.image = UIImage(named: kCalendarIcon)
        } else {
            cell.addkTaskImageViewLeadingConstraint.constant = -10.0
        }
        return cell
    }
    
    func priorityCell(indexPath : IndexPath) -> AddTaskCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = priorityArray[indexPath.row]
        cell.secondaryTextLabel.text = ""
        return cell
    }
    
    func labelCell(indexPath : IndexPath) -> AddTaskCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView?.image = nil
        if indexPath.section == 0 {
            if let labels = labels {
                cell.primayTextLabel.text = labels[indexPath.row].labelName
                cell.addTaskImageView.image = UIImage(named: kListIcon)
            } else {
                cell.primayTextLabel.text = self.LoadingLabelsMsg
                cell.addkTaskImageViewLeadingConstraint.constant = -10.0
            }
        } else {
            cell.primayTextLabel.text = kNewList
            cell.addTaskImageView.image = UIImage(named: kAddIcon)
        }
        
        cell.secondaryTextLabel.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableState {
        case .priority:
            return priorityCell(indexPath: indexPath)
        case .dueDate:
            return dateCell(indexPath: indexPath)
        case .label:
            return labelCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - selected row in table view
    func handlePrioritySelected(_ indexPath : IndexPath) {
        if indexPath.row == priorityArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskPriority = nil
        } else {
            textView.text = textView.text + String(indexPath.row + 1)
            priorityButton.isUserInteractionEnabled = false
            priorityButton.isHighlighted = true
            task.taskPriority = indexPath.row + 1
        }
    }

    func handleDateSelected(_ indexPath : IndexPath) {
        
        if indexPath.section == 1 {
            // show a calendar view
            performSegue(withIdentifier: kShowCalendarSegue, sender: self)
            return;
        }
        if indexPath.row == dateArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskDate = nil
        } else {
            textView.text = textView.text + dateArray[indexPath.row]
            dateButton.isUserInteractionEnabled = false
            dateButton.isHighlighted = true
            let today = Date()
            task.taskDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: today)
        }
    }
    
    func handleLabelSelected(_ indexPath : IndexPath) {
        
        if indexPath.section == 1 {
            // show a calendar view
            performSegue(withIdentifier: kShowAddLabelScreen, sender: self)
            return;
        }
        
        textView.text = textView.text + dateArray[indexPath.row]
        listButton.isUserInteractionEnabled = false
        listButton.isHighlighted = true
        task.taskList = labels![indexPath.row].labelName
    }
    
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableState {
        case .priority:
            handlePrioritySelected(indexPath)
        case .dueDate:
            handleDateSelected(indexPath)
        case .label:
            handleLabelSelected(indexPath)
        default:
            break
        }

        tableState = .none
        tableView.isHidden = true
        maskView.isHidden = false
    }
    
}

// MARK: - UITextViewDelegate
extension AddTaskViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text
        let textArray = Array(text!.characters)
        

        // 1. button view
        unhideButtonViewIfRequired(textArray)
        
        // 2. table view
        setTableViewState(textArray)
        
        // 3. priority button
        setPriorityButtonState(textArray)
        
        // 4. date button
        setDateButtonState()
    }
    
    func setDateButtonState() {
        dateButton.isHighlighted = false
        dateButton.isUserInteractionEnabled = true
        for ix in 0..<dateArray.count {
            let testString = String(kDateSpecialCharacter) + dateArray[ix]
            if textView.text.contains(testString) {
                dateButton.isHighlighted = true
                dateButton.isUserInteractionEnabled = false
                if task.taskDate == nil {
                    let today = Date()
                    task.taskDate = Calendar.current.date(byAdding: .day, value: ix, to: today)
                }
                break
            }
        }
        
        let pattern = "\\" + TaskSpecialCharacter.dueDate.stringValue() + "\\d{1,2}\\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s+\\d{4}"
        if let range = textView.text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty {
            dateButton.isHighlighted = true
            dateButton.isUserInteractionEnabled = false
            if task.taskDate == nil {
                let subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
                let dateString = textView.text.substring(with: subRange)
                AddTaskViewController.dateFormatter.dateFormat = "dd MMM yyyy"
                task.taskDate = AddTaskViewController.dateFormatter.date(from: dateString)
            }
        }
        
        if dateButton.isUserInteractionEnabled == true {
            task.taskDate = nil
        }
    }
    
    func setPriorityButtonState(_ textArray : [Character]) {
        
        priorityButton.isHighlighted = true
        priorityButton.isUserInteractionEnabled = false
        if textView.text.contains(kPriorityHigh) == false &&
            textView.text.contains(kPriorityMedium) == false &&
            textView.text.contains(kPriorityLow) == false {
            
            priorityButton.isHighlighted = false
            priorityButton.isUserInteractionEnabled = true
            task.taskPriority = nil
        }
        
        let pattern = "\\" + TaskSpecialCharacter.priority.stringValue() + "(1|2|3)"
        if let range = textView.text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty, task.taskPriority == nil {
            let subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
            let priorityString = textView.text.substring(with: subRange)
            task.taskPriority = Int(priorityString)
        }
    }
    
    func unhideButtonViewIfRequired(_ textArray : [Character]) {
        if textArray.count > 0 && self.buttonView.isHidden == true {
            self.buttonView.isHidden = false
            self.view.setNeedsDisplay()
        }
    }
    
    func setTableViewState(_ textArray : [Character]) {
        
        // 1. handle hide scenarios
        var hideTableView = textArray.count == 0 || tableState == .none
        if textArray.count > 0,
            let specialCharacter = tableStateToCharacterMap[tableState] {
            hideTableView = textArray[textArray.count - 1] != specialCharacter.rawValue
        }
        
        if hideTableView {
            self.tableView.isHidden = true
            self.maskView.isHidden = false
            tableState = .none
            view.setNeedsDisplay()
        }

        // 2. handle unhide scenarios
        if textArray.count > 0 && tableState == .none {
            
            if let specialChar = TaskSpecialCharacter(rawValue: textArray[textArray.count - 1]),
                let state = specialCharacterToTableStateMap[specialChar] {
                 tableState = state
                handleButtonTapped(state: state, char: specialChar.rawValue)
            }
        }
    }
}
