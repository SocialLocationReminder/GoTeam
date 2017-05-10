//
//  ContactsAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit
import KBContactsSelection

class ContactsAnnotationController : NSObject, AnnotationControllerProtocol {
    
    
    weak internal var delegate: AnnotationControllerDelegate?
    
    var tableFilter : String?
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    static let kNumberOfSections = 1
    var annotationType : AnnotationType!
    
    var kbContactsController : KBContactsSelectionViewController!
    
    // application layer
    let contactManager = ContactManager.sharedInstance
    
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task) {
        
        self.textView = textView
        self.annotationType = annotationType
        self.task = task
        self.button = button
        
        setupGestureRecognizer()
    }
    
    func clearAnnotationInTask() {
        
    }
    
    func setupGestureRecognizer() {
        button.isUserInteractionEnabled = true
        button.isHighlighted = false
        let locationTapGR = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(locationTapGR)
    }
    
    
    // MARK: - gesture recognizer
    @objc func buttonTapped(sender : UITapGestureRecognizer) {
        userTriggedAnnotation()
    }
    
    
    // MARK: - button state
    func setButtonStateAndAnnotation() {
        
    }
    
    func userTriggedAnnotation() {
        setupKBContactsController() // doing this each time to clear state, no other way
        delegate?.present(sender: self, controller: kbContactsController)
    }
    
    // MARK: - Table View data source related
    func numberOfSections() -> Int {
        // not used for contacts
        assert(false)
        return 0
    }
    
    func numberOfRows(section: Int) -> Int {
        // not used for contacts
        assert(false)
        return 0
    }
    
    func populate(cell : AddTaskCell, indexPath : IndexPath)  {
        // not used for contacts
        assert(false)
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        // not used for contacts
        assert(false)
    }
    
    func setupKBContactsController() {
        
        kbContactsController = KBContactsSelectionViewController(configuration: { (config) in
            config?.shouldShowNavigationBar = true
            // config?.tintColor = UIColor.blue
            config?.title = Resources.Strings.Contacts.kNavigationBarTitle
            config?.selectButtonTitle = Resources.Strings.AddTasks.kSelectContacts
            config?.mode = KBContactsSelectionMode.messages
            config?.skipUnnamedContacts = true
            config?.customSelectButtonHandler = { (contacts : Any!) in
                self.kbContactsController.dismiss(animated: true, completion: nil)
                if let contacts = contacts as? [APContact] {
                    self.contactsSelected(contacts: contacts)
                }
            }
            config?.contactEnabledValidation = { (contact : Any) in
                return true
            }
        })
        kbContactsController.title = Resources.Strings.Contacts.kNavigationBarTitle
        kbContactsController.delegate = self
    }
}

extension ContactsAnnotationController : KBContactsSelectionViewControllerDelegate {
    
    func contactsSelected(contacts : [APContact]) {
        
        if contacts.count > 0 {
            delegate?.removeFromTextView(sender:self, character: TaskSpecialCharacter.contact.stringValue())
        }
        
        for contact in contacts {
            // @todo: replace this with first name
            let fullName = contact.fullName()
            if let fullName = fullName {
                
                let str = TaskSpecialCharacter.contact.stringValue() + fullName
                delegate?.appendToTextView(sender: self, string: str)
                delegate?.attributeTextView(sender: self, pattern: str, options: .caseInsensitive,
                                            fgColor: Resources.Colors.Annotations.kContactFGColor,
                                            bgColor: Resources.Colors.Annotations.kContactBGColor)
                if task.taskContacts == nil {
                    task.taskContacts = [Contact]()
                }
                if task.taskContactsSubranges == nil {
                    task.taskContactsSubranges = [Range<String.Index>]()
                }
                let contactObj = Contact.contact(apContact: contact)
                contactManager.add(contact: contactObj, success: {
                    print("sucess in adding contact")
                    }, error: { (error) in
                        // @todo: show error
                        print("error in saving contact")
                })
                task.taskContacts?.append(contactObj)
                if let range = textView.text.range(of: str) {
                    task.taskContactsSubranges?.append(range)
                }
            }
        }
        textView.becomeFirstResponder()
    }
}

