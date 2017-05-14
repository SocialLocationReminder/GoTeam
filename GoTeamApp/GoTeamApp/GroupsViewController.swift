//
//  GroupsViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import KBContactsSelection
import MetalKit

class GroupsViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    // application layer
    let contactManager = ContactManager.sharedInstance
    
    var kbContactsController : KBContactsSelectionViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKBContactsController()
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    func setupButton() {
        addButton.layer.cornerRadius = 48.0 / 2.0
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
    }
    
    func buttonPressed() {
        present(kbContactsController, animated: true, completion: nil)
    }
    
    
    func setupKBContactsController() {
        
        kbContactsController = KBContactsSelectionViewController(configuration: { (config) in
            config?.shouldShowNavigationBar = true
            // config?.tintColor = UIColor.blue
            config?.title = Resources.Strings.Contacts.kNavigationBarTitle
            config?.selectButtonTitle = Resources.Strings.Contacts.kAddTaskNavItem
            
            config?.mode = KBContactsSelectionMode.messages
            config?.skipUnnamedContacts = true
            config?.customSelectButtonHandler = { (contacts : Any!) in
                print(contacts)
                if let contacts = contacts as? [APContact] {
                    self.contactsSelected(contacts:contacts)
                }
            }
            config?.contactEnabledValidation = { (contact : Any) in
                return true
            }
        })
    }
    
    func contactsSelected(contacts : [APContact]) {
        
        // 1. add contacts to parse
        var contactsArray = [Contact]()
        for contact in contacts {
            let contactObj = Contact.contact(apContact: contact)
            contactsArray.append(contactObj)
            contactManager.add(contact: contactObj, success: {
                print("sucess in adding contact")
                }, error: { (error) in
                    // @todo: show error
                    print("error in saving contact")
            })
        }
        
        // 2. @todo: prompt for a new group name here
        
        // 3. create the group entity and add all the contacts above to the
        // 'contacts' array filed
        let group = Group()
        group.groupName = "Test Group Name" // change this to the one received above
        group.contacts = contactsArray
        
        // 4. @todo: Add the newly created group entity to parse, create a new GroupManager and
        // GropuDataStoreService similar to LabelManager and LabelDataStoreService
        // have a look at TaskDataStoreService to see how I associated multiple contacts with a task,
        // something similar thas to be done to associate multiple contact entities with a single
        // group entity

        
        // 5. @todo: Append the newly created group to the table view.
        
        // 6. dimiss the kbContactsController
        kbContactsController.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
