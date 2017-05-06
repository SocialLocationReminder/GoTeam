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
    case recurrence
    case location
}

class AddTaskViewController: UIViewController {

    static let dateFormatter = DateFormatter()
    
    let kShowCalendarSegue = "showCalendarSegue"
    let kShowAddLabelScreen = "showAddLabelScreen"
    
    let kPriorityHigh = "!1"
    let kPriorityMedium = "!2"
    let kPriorityLow = "!3"
    
    
    var labelsMsg     : String!
    var locationsMsg  : String!
    
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
            TableState.dueDate : TaskSpecialCharacter.dueDate,
            TableState.recurrence : TaskSpecialCharacter.recurrence,
            TableState.location : TaskSpecialCharacter.location
        ]

    // constructed by swapping the keys and values of the above map
    var specialCharacterToTableStateMap = [TaskSpecialCharacter : TableState]()

    
    let priorityArray = ["1 - High", "2 - Medium", "3 - Low", "None"]
    var dateArray = ["Today", "Tomorrow", "", "", "", "1 week", "No due date"]
    let recurrenceArray = ["Every day", "Every week", "Every month", "Every year", "After a day", "After a week", "After a month", "After a year", "No repeat"]
    
    // application layer
    let labelManager = LabelManager.sharedInstance
    var labels : [Labels]?
    let locationManager = SelectedLocationsManager.sharedInstance
    var locations : [Location]?

    
    // MARK: - init/load related
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // 1. setup text view
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.text = ""
        textView.accessibilityHint = ""
        
        
        // 2. setup mask view
        buttonView.isHidden = true
        
        
        // 3. setup table view
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        // 4. setup button
        setupPriorityButton()
        
        // 5. setup due date
        setupDate()
        
        // 6. new task
        task = Task()

        // 7. fetch labels
        setupLabelButton()
        
        // 8. recurrence
        setupRecurrenceButton()
        
        // 9. locations
        setupLocationButton()
        
        tableStateToCharacterMap.forEach { (k, v) in
            specialCharacterToTableStateMap[v] = k
        }
    }
    
    
    func setupLocationButton() {
        locationButton.isUserInteractionEnabled = true
        locationButton.isHighlighted = false
        let locationTapGR = UITapGestureRecognizer(target: self, action: #selector(locationButtonTapped(sender:)))
        locationButton.addGestureRecognizer(locationTapGR)
        self.locationsMsg = Resources.Strings.AddTasks.kLoadingLocations
        fetchLocations()
    }
    
    func setupRecurrenceButton() {
        repeatButton.isUserInteractionEnabled = true
        repeatButton.isHighlighted = false
        let repeatTapGR = UITapGestureRecognizer(target: self, action: #selector(repeatButtonTapped(sender:)))
        repeatButton.addGestureRecognizer(repeatTapGR)
    }
    
    func setupLabelButton() {
        listButton.isUserInteractionEnabled = true
        listButton.isHighlighted = false
        let listTapGR = UITapGestureRecognizer(target: self, action: #selector(labelButtonTapped))
        listButton.addGestureRecognizer(listTapGR)
        self.labelsMsg = Resources.Strings.AddTasks.kLoadingLabels
        fetchLabels()
    }
    
    func fetchLocations() {
        locationManager.allLocations(fetch: true, success: { (locations) in
            if self.tableState == .location {
                self.tableView.reloadData()
            }
        }) { (error) in
            self.locationsMsg = Resources.Strings.AddTasks.kFailedLoadingLabels
        }
    }
    
    func fetchLabels() {
        labelManager.allLabels(fetch: true, success: { (labels) in
            self.labels = labels
            if self.tableState == .label {
                self.tableView.reloadData()
            }
            }) { (error) in
                if self.tableState == .label {
                    self.labelsMsg = Resources.Strings.AddTasks.kFailedLoadingLocations
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

    // MARK: - Gesture Recognizer handlers
    func dateButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .dueDate, char : TaskSpecialCharacter.dueDate.rawValue)
    }

    
    func priorityButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .priority, char : TaskSpecialCharacter.priority.rawValue)
    }
    
    func labelButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .label, char : TaskSpecialCharacter.label.rawValue)
    }
    
    func repeatButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .recurrence, char: TaskSpecialCharacter.recurrence.rawValue)
    }

    func locationButtonTapped(sender : UITapGestureRecognizer) {
        handleButtonTapped(state: .location, char: TaskSpecialCharacter.location.rawValue)
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
    
    
    // MARK: - unwind segues
    
    @IBAction func unwindCancelToAddTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }

    @IBAction func unwindDoneAddTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        if let calendarVC = segue.source as? CalendarViewController {
            
            let dateSelected = calendarVC.dateSelected ?? Date()
            AddTaskViewController.dateFormatter.dateFormat = "dd MMM yyyy"
            let dateSelectedStr = AddTaskViewController.dateFormatter.string(from: dateSelected)
            appendToTextView(string: dateSelectedStr)
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
        case .recurrence:
            return 1
        case .location:
            return 1
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
        case .recurrence:
            return recurrenceArray.count
        case .location:
            return locations?.count ?? 1
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Resources.Strings.AddTasks.kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = indexPath.section == 0 ? dateArray[indexPath.row] : Resources.Strings.AddTasks.kPickADate
        if indexPath.section == 0 {
            let today = Date()
            let labelDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: today)
            AddTaskViewController.dateFormatter.dateFormat = "MMM d"
            cell.secondaryTextLabel.text = AddTaskViewController.dateFormatter.string(from: labelDate!)
            cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kCalendarIcon)
        } else {
            cell.addkTaskImageViewLeadingConstraint.constant = -10.0
        }
        return cell
    }
    
    func priorityCell(indexPath : IndexPath) -> AddTaskCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Resources.Strings.AddTasks.kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView?.image = nil
        cell.primayTextLabel.text = priorityArray[indexPath.row]
        cell.secondaryTextLabel.text = ""
        return cell
    }
    
    func labelCell(indexPath : IndexPath) -> AddTaskCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier:Resources.Strings.AddTasks.kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView?.image = nil
        if indexPath.section == 0 {
            if let labels = labels {
                cell.primayTextLabel.text = labels[indexPath.row].labelName
                cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kListIcon)
            } else {
                cell.primayTextLabel.text = self.labelsMsg
                cell.addkTaskImageViewLeadingConstraint.constant = -10.0
            }
        } else {
            cell.primayTextLabel.text = Resources.Strings.AddTasks.kNewList
            cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kAddIcon)
        }
        
        cell.secondaryTextLabel.text = ""
        return cell
    }
    
    func recurrenceCell(indexPath : IndexPath) -> AddTaskCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Resources.Strings.AddTasks.kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kRecurringIcon)
        cell.primayTextLabel.text = recurrenceArray[indexPath.row]
        cell.secondaryTextLabel.text = ""
        return cell
    }
    
    func locationCell(indexPath : IndexPath) -> AddTaskCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Resources.Strings.AddTasks.kAddTaskCell) as! AddTaskCell
        cell.addTaskImageView.image = UIImage(named: Resources.Images.Tasks.kLocationIcon)
        cell.primayTextLabel.text = SelectedLocationsManager.sharedInstance.locations[indexPath.row].title
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
        case .recurrence:
            return recurrenceCell(indexPath: indexPath)
        case .location:
            return locationCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - selected row in table view
    
    func handleRecurrenceSelected(_ indexPath : IndexPath) {
        
        if indexPath.row == recurrenceArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskRecurrence = nil
        } else {
            appendToTextView(string: String(recurrenceArray[indexPath.row]))
        }
    }
    

    func handlePrioritySelected(_ indexPath : IndexPath) {
        if indexPath.row == priorityArray.count - 1  {
            let chars = Array(textView.text.characters)
            textView.text = String(chars[0..<chars.count - 2])
            task.taskPriority = nil
        } else {
            appendToTextView(string: String(indexPath.row + 1))
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
            appendToTextView(string: dateArray[indexPath.row])
        }
    }
    
    func handleLabelSelected(_ indexPath : IndexPath) {
        
        if indexPath.section == 1 {
            // show add label screen
            performSegue(withIdentifier: kShowAddLabelScreen, sender: self)
            return;
        }
        
        if let labelName = labels![indexPath.row].labelName {
            appendToTextView(string: labelName)
        }
    }

    func handleLocationSelected(_ indexPath : IndexPath) {
        if let locationName = SelectedLocationsManager.sharedInstance.locations[indexPath.row].title {
            appendToTextView(string: locationName)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableState {
        case .priority:
            handlePrioritySelected(indexPath)
        case .dueDate:
            handleDateSelected(indexPath)
        case .label:
            handleLabelSelected(indexPath)
        case .recurrence:
            handleRecurrenceSelected(indexPath)
        case .location:
            handleLocationSelected(indexPath)
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
        setButtonViewState(textArray)
        
        // 2. table view
        setTableViewState(textArray)
        
        // 3. priority button
        setPriorityButtonState()
        
        // 4. date button
        setDateButtonState()
        
        // 5. label button
        setLabelButtonState()
        
        // 6. recurrence button
        setRecurrenceButtonState()
        
        // 7. location button
        setLocationButtonState()
    }
    
    func setLocationButtonState() {
        locationButton.isHighlighted = false
        locationButton.isUserInteractionEnabled = true
        for ix in 0..<SelectedLocationsManager.sharedInstance.locations.count {
            let location = SelectedLocationsManager.sharedInstance.locations[ix]
            let testString = TaskSpecialCharacter.location.stringValue() + location.title!
            if textView.text.contains(testString) {
                locationButton.isHighlighted = true
                locationButton.isUserInteractionEnabled = false
                if task.taskLocation == nil {
                    
                    task.taskLocation = location
                    task.taskLabelSubrange = textView.text.range(of: testString)
                    attributeTextView(pattern: testString, options: .caseInsensitive,
                                      fgColor: UIColor.white, bgColor: UIColor.gray)
                }
                
                break
            }
        }
        
        if repeatButton.isUserInteractionEnabled == true {
            task.taskRecurrence = nil
            task.taskRecurrenceSubrange = nil
        }
    }
    
    func setRecurrenceButtonState() {
        
        repeatButton.isHighlighted = false
        repeatButton.isUserInteractionEnabled = true
        for ix in 0..<recurrenceArray.count {
            let testString = TaskSpecialCharacter.recurrence.stringValue() + recurrenceArray[ix]
            if textView.text.contains(testString) {
                repeatButton.isHighlighted = true
                repeatButton.isUserInteractionEnabled = false
                if task.taskRecurrence == nil {
                    
                    // @todo: need to support multiple labels
                    task.taskRecurrence = ix
                    task.taskRecurrenceSubrange = textView.text.range(of: testString)
                    attributeTextView(pattern: testString, options: .caseInsensitive,
                                      fgColor: UIColor.white, bgColor: UIColor.green)
                }
                
                break
            }
        }
        
        if repeatButton.isUserInteractionEnabled == true {
            task.taskRecurrence = nil
            task.taskRecurrenceSubrange = nil
        }

    }
    
    func setLabelButtonState() {
        
        guard let _ = labels else { return; }
        
        listButton.isHighlighted = false
        listButton.isUserInteractionEnabled = true
        for ix in 0..<labels!.count {
            if let labelName = labels![ix].labelName {
                let testString = TaskSpecialCharacter.label.stringValue() + labelName
                if textView.text.contains(testString) {
                    listButton.isHighlighted = true
                    listButton.isUserInteractionEnabled = false
                    if task.taskLabel == nil {

                        // @todo: need to support multiple labels
                        task.taskLabel = labelName
                        task.taskLabelSubrange = textView.text.range(of: testString)
                        attributeTextView(pattern: testString, options: .caseInsensitive,
                                          fgColor: UIColor.white, bgColor: UIColor.cyan)
                    }
                    
                    break
                }
            }
        }
        if listButton.isUserInteractionEnabled == true {
            task.taskLabel = nil
            task.taskLabelSubrange = nil
        }
    }
    
    func setDateButtonState() {
        dateButton.isHighlighted = false
        dateButton.isUserInteractionEnabled = true
        for ix in 0..<dateArray.count {
            let testString = TaskSpecialCharacter.dueDate.stringValue() + dateArray[ix]
            if textView.text.contains(testString) {
                dateButton.isHighlighted = true
                dateButton.isUserInteractionEnabled = false
                if task.taskDate == nil {
                    let today = Date()
                    task.taskDate = Calendar.current.date(byAdding: .day, value: ix, to: today)
                    task.taskDateSubrange = textView.text.range(of: testString)
                    attributeTextView(pattern: testString, options: .caseInsensitive,
                                      fgColor: UIColor.white, bgColor: UIColor.brown)
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
                task.taskDateSubrange = range
                attributeTextView(pattern: pattern, options: .regularExpression,
                                  fgColor: UIColor.white, bgColor: UIColor.brown)
            }
        }
        
        if dateButton.isUserInteractionEnabled == true {
            task.taskDate = nil
            task.taskDateSubrange = nil
        }
    }
    

    func setPriorityButtonState() {
        
        priorityButton.isHighlighted = true
        priorityButton.isUserInteractionEnabled = false
        if textView.text.contains(kPriorityHigh) == false &&
            textView.text.contains(kPriorityMedium) == false &&
            textView.text.contains(kPriorityLow) == false {
            
            priorityButton.isHighlighted = false
            priorityButton.isUserInteractionEnabled = true
            task.taskPriority = nil
            task.taskPrioritySubrange = nil
            // @todo: change the attribute color here for the "!"
        }
        
        let pattern = "\\" + TaskSpecialCharacter.priority.stringValue() + "(1|2|3)"
        
        if let range = textView.text.range(of: pattern, options: .regularExpression, range: nil, locale: nil),
            !range.isEmpty, task.taskPriority == nil {
            let subRange = Range(uncheckedBounds: (textView.text.index(after: range.lowerBound), range.upperBound))
            let priorityString = textView.text.substring(with: subRange)
            task.taskPriority = Int(priorityString)
            task.taskPrioritySubrange = range
            
            // attribute the text
            attributePriorityText()
        }
    }
 
    
    func setButtonViewState(_ textArray : [Character]) {
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
    
    
    func attributePriorityText() {
        
        let pattern = "\\" + TaskSpecialCharacter.priority.stringValue() + "(1|2|3)"
        
        if let taskPriority = task.taskPriority {
            var bgColor = UIColor.white
            if taskPriority == 1 {
                bgColor = UIColor.red
            } else if taskPriority == 2 {
                bgColor = UIColor.blue
            } else if taskPriority == 3 {
                bgColor = UIColor.orange
            }
            attributeTextView(pattern: pattern, options: .regularExpression,
                              fgColor: UIColor.white, bgColor: bgColor)
        }
    }
    
    func appendToTextView(string : String) {
        if textView.attributedText.length > 0 {
            let attributedStr = NSMutableAttributedString(attributedString: textView.attributedText)
            attributedStr.append(NSAttributedString(string: string))
            textView.attributedText = attributedStr
        } else {
            textView.text = textView.text + string
        }
    }
    
    
    func attributeTextView(pattern : String, options: NSString.CompareOptions, fgColor : UIColor, bgColor : UIColor) {
        
        let objString = textView.text as NSString
        let range = objString.range(of: pattern, options: options)
        var attributedString : NSMutableAttributedString!
        
        if textView.attributedText.length > 0 {
            attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
            attributedString.append(NSAttributedString(string: " "))
        } else {
            attributedString = NSMutableAttributedString(string: textView.text + " ")
        }
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: fgColor, range: range)
        attributedString.addAttribute(NSBackgroundColorAttributeName, value: bgColor, range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(objString.length, 1))
        textView.attributedText = attributedString
    }
}
