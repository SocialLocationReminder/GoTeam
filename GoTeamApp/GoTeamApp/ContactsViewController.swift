//
//  ContactsViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/6/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import KBContactsSelection

class ContactsViewController: KBContactsSelectionViewController {

    var kbContactsController : KBContactsSelectionViewController!
    
    @IBOutlet weak var contactsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.delegate = self
        setupKBContactsController()
    }
    
    func setupKBContactsController() {
        
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
        kbContactsController.navigationItem.hidesBackButton = true

        
        
        // self.view.addSubview(kbContactsController.view)
        // self.addChildViewController(kbContactsController)
        // kbContactsController.didMove(toParentViewController: self)
      //  self.present(kbContactsController, animated: false, completion: nil)
        // self.navigationController?.viewControllers = [self, kbContactsController]

        // self.contactsView.addSubview(kbContactsController.view)
        // self.addChildViewController(kbContactsController)
        // kbContactsController.didMove(toParentViewController: self)
    }
    
    func cancelTapped() {
        print("cancel tapped")
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
