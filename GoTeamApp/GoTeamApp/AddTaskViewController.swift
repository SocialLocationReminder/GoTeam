//
//  AddTaskViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/26/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import KBContactsSelection


enum ViewControllerState {
    case addMode
    case editMode
}

class AddTaskViewController: UIViewController {

    static let dateFormatter = DateFormatter()
    
    // --- outlets ---
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
    var viewControllerState = ViewControllerState.addMode
    
    // --- table view related ---
    var tableState : AnnotationType = .none


    // annotations
    var annnotationTypeToControllerMap = [AnnotationType : AnnotationControllerProtocol]()
    var annotationTypes : [AnnotationType]!
    var annotationControllers : [AnnotationControllerProtocol]!
    var annotationTypeToCharacterMap : [AnnotationType : TaskSpecialCharacter] =
        [
            .priority : TaskSpecialCharacter.priority,
            .label : TaskSpecialCharacter.label,
            .dueDate : TaskSpecialCharacter.dueDate,
            .recurrence : TaskSpecialCharacter.recurrence,
            .location : TaskSpecialCharacter.location,
            .contact : TaskSpecialCharacter.contact
    ]
    
    var specialHandlingAnnotationTypes : [AnnotationType]!
    
    // constructed by swapping the keys and values of the above map
    var specialCharacterToTableStateMap = [TaskSpecialCharacter : AnnotationType]()

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

        // 4. new task
        task = Task()

        // 5. setup annotation controllers
        setupAnnotationControllers()

        // setup specialCharacterToTableStateMap
        annotationTypeToCharacterMap.forEach { (k, v) in
            specialCharacterToTableStateMap[v] = k
        }
        
        if viewControllerState == .editMode {
            self.title = Resources.Strings.AddTasks.kEditScreenTitle
            addAnnotatedTextToTextView()
        } else {
            self.title = Resources.Strings.AddTasks.kAddScreenTitle
        }
    }
    
    func addAnnotatedTextToTextView() {
        guard task.taskNameWithAnnotations != nil else { return; }
        if let attributedString = NSKeyedUnarchiver.unarchiveObject(with: task.taskNameWithAnnotations!) as? NSAttributedString {
            textView.attributedText = attributedString
        }
    }
    
    func setupAnnotationControllers() {
        annotationTypes = [.priority, .label, .dueDate, .recurrence, .location, .contact]
        annotationControllers =
            [
                PriorityAnnotationController(), LabelAnnotationController(), DateTimeAnnotationController(),
                RecurrenceAnnotationController(), LocationAnnotationController(), ContactsAnnotationController()
        ]
        let buttons : [UIImageView] = [priorityButton, listButton, dueDateButton, repeatButton, locationButton, contactButton]
        for ix in 0..<annotationControllers.count {
            annotationControllers[ix].setup(button: buttons[ix], textView: textView, annotationType: annotationTypes[ix], task: task)
            annotationControllers[ix].delegate = self
        }
        
        specialHandlingAnnotationTypes = [.contact]
    }
    
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
    }

    
    // MARK: - unwind segues and prepare for segue
    @IBAction func unwindCancelToAddTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }

    @IBAction func unwindDoneAddTasksViewControllerSegue(_ segue : UIStoryboardSegue) {
        if segue.identifier == Resources.Strings.DateTimeAnnotationController.kUnwindCalendarSegue,
            let calendarVC = segue.source as? CalendarViewController,
            let annotationType = calendarVC.annotationType,
            let ix = indexFor(annotationType: annotationType) {
            annotationControllers[ix].unwind?(segue: segue)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Resources.Strings.DateTimeAnnotationController.kShowCalendarSegue,
            let navVC = segue.destination as? UINavigationController,
            let calendarVC = navVC.topViewController as? CalendarViewController {
            calendarVC.annotationType = tableState
        }
    }
}



//MARK: - UITableViewDelegate, UITableViewDataSource
extension AddTaskViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let annotationTypeIx = indexFor(annotationType: tableState) {
            return annotationControllers[annotationTypeIx].numberOfSections()
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let annotationTypeIx = indexFor(annotationType: tableState) {
            return annotationControllers[annotationTypeIx].numberOfRows(section: section)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 30.0 : 0.0
    }
    
    
    func indexFor(annotationType : AnnotationType) -> Int? {

        for jx in 0..<annotationTypes.count {
            if annotationTypes[jx] == annotationType {
                return jx
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let annotationTypeIx = indexFor(annotationType: tableState) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Strings.AddTasks.kAddTaskCell) as! AddTaskCell
            annotationControllers[annotationTypeIx].populate(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    
    // MARK: - selected row in table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let annotationTypeIx = indexFor(annotationType: tableState) {
            annotationControllers[annotationTypeIx].didSelect(indexPath)
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
        
        // 3. annotation controller button states
        for controller in annotationControllers {
            controller.setButtonState()
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
            let specialCharacter = annotationTypeToCharacterMap[tableState] {
            hideTableView = textArray[textArray.count - 1] != specialCharacter.rawValue
        }
        
        if hideTableView {
            self.tableView.isHidden = true
            self.maskView.isHidden = false
            tableState = .none
            self.tableView.reloadData()
        }

        // 2. handle unhide scenarios
        if textArray.count > 0 && tableState == .none {
            
            if let specialChar = TaskSpecialCharacter(rawValue: textArray[textArray.count - 1]),
                let state = specialCharacterToTableStateMap[specialChar] {
                    tableState = state
                    for specialHandling in specialHandlingAnnotationTypes {
                        if specialHandling == state {
                            if let ix = indexFor(annotationType: state) {
                                annotationControllers[ix].userTriggedAnnotation?()
                            }
                            return;
                        }
                    }
                    showTable(annotationType: state)
            }
        }
    }
    

    

}

extension AddTaskViewController : AnnotationControllerDelegate {
    
    func reloadTable(sender : AnnotationControllerProtocol, annotationType: AnnotationType) {
        self.tableView.reloadData()
    }
    
    func buttonTapped(sender : AnnotationControllerProtocol, annotationType: AnnotationType) {
        showTable(annotationType: annotationType)
    }
    
    func showTable(annotationType: AnnotationType) {
        if let char = annotationTypeToCharacterMap[annotationType] {
            let text = textView.text
            let textArray = Array(text!.characters)
        
        
            if textArray.count == 0 || textArray[textArray.count - 1] != char.rawValue {
                if textArray.count > 0 && textArray[textArray.count - 1] != " " {
                    textView.text = textView.text + " "
                }
                textView.text = textView.text + char.stringValue()
            }
        
            tableView.isHidden = false
            maskView.isHidden = true
            tableState = annotationType
            tableView.reloadData()
        }
    }

    
    func appendToTextView(sender: AnnotationControllerProtocol, string : String) {
        appendToTextView(string: string)
    }
    
    internal func appendToTextView(string : String) {
        if textView.attributedText.length > 0 {
            let attributedStr = NSMutableAttributedString(attributedString: textView.attributedText)
            attributedStr.append(NSAttributedString(string: string))
            textView.attributedText = attributedStr
        } else {
            textView.text = textView.text + string
        }
    }
    
    func removeFromTextView(sender: AnnotationControllerProtocol, character : String) {
        if textView.attributedText.length > 0 {
            let attributedStr = NSMutableAttributedString(attributedString: textView.attributedText)
            let textArray = Array(attributedStr.string.characters)
            if String(textArray[textArray.count - 1]) == character {
                attributedStr.deleteCharacters(in: NSMakeRange(attributedStr.length - 1, 1))
                textView.attributedText = attributedStr
            }
        } else {
            let textArray = Array(textView.text.characters)
            if textArray.count > 0 && String(textArray[textArray.count - 1]) == character {
                if var text = textView.text {
                    text.remove(at: text.index(before: text.endIndex))
                    textView.text = text
                }
            }
        }
    }
    
    
    
    internal func attributeTextView(sender: AnnotationControllerProtocol, pattern : String, options: NSString.CompareOptions, fgColor : UIColor, bgColor : UIColor) {
        
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
    
    // present and peform segue
    func present(sender: AnnotationControllerProtocol, controller : UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func perform(sender : AnnotationControllerProtocol, segue : String) {
        performSegue(withIdentifier: segue, sender: self)
    }
    
}


