//
//  ContactsViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/6/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import KBContactsSelection

class ContactsViewController: UIViewController {

    var kbContactsController : KBContactsSelectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKBContactsController()
    }
    
    func setupKBContactsController() {
        kbContactsController = KBContactsSelectionViewController(configuration: { (config) in
            config?.shouldShowNavigationBar = false
            config?.tintColor = UIColor.blue
            config?.title = "Push"
            config?.selectButtonTitle = "Add"
            
            config?.mode = KBContactsSelectionMode.messages
            config?.skipUnnamedContacts = true
            config?.customSelectButtonHandler = { (contacts : Any!) in
                print(contacts)
            }
            config?.contactEnabledValidation = { (contact : Any) in
                return true
            }
        })
        kbContactsController.delegate = self
        self.present(kbContactsController, animated: false, completion: nil)
        
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
