//
//  ContactsViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/6/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import KBContactsSelection
import MBProgressHUD

class ContactsViewController: KBContactsSelectionViewController {

    var kbContactsController : KBContactsSelectionViewController!
    var contacts : [Contact]?
    
    @IBOutlet weak var contactsView: UIView!
    
    // application layer
    let contactManager = ContactManager.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.delegate = self
        setupKBContactsController()
    }
    
    func fetchContacts() {
        self.contacts = [Contact]()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        contactManager.fetchAllContacts(success: { (contacts) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.contacts = contacts
            }
        }) { (error) in
            DispatchQueue.main.async {
                // @todo: show network error
                hud.hide(animated: true)
            }
        }
    }
    
    func setupKBContactsController() {
        fetchContacts()
        kbContactsController = KBContactsSelectionViewController(configuration: { (config) in
            config?.shouldShowNavigationBar = false
           // config?.tintColor = UIColor.blue
            config?.title = Resources.Strings.Contacts.kNavigationBarTitle
            config?.selectButtonTitle = Resources.Strings.Contacts.kAddTaskNavItem
            
            config?.mode = KBContactsSelectionMode.messages
            config?.skipUnnamedContacts = true
            config?.customSelectButtonHandler = { (contacts : Any!) in
                print(contacts)
            }
            config?.contactEnabledValidation = { (contact : Any) in
                return true
            }
        })
        kbContactsController.title = Resources.Strings.Contacts.kNavigationBarTitle
        kbContactsController.delegate = self
        navigationController?.pushViewController(kbContactsController, animated: false)
    }
    
    func cancelTapped() {
        print("cancel tapped")
    }

    func contactsSelected(contacts : [APContact]) {
        
        for contact in contacts {
            let contactObj = Contact.contact(apContact: contact)
            contactManager.add(contact: contactObj, success: {
                print("sucess in adding contact")
                }, error: { (error) in
                    // @todo: show error
                    print("error in saving contact")
            })
        }
        
        // @todo: prompt for a new group name here
        
        // @todo: create the group and pass it back in a delegate call to 
        // GroupsViewController and add it to the table view as well as add it to 
        // Parse as 'Group' entity.
        
        // @todo: dimiss this modal view
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

extension ContactsViewController : KBContactsSelectionViewControllerDelegate {
    
}
