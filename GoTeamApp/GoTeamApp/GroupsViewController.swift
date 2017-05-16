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
import MBProgressHUD

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var circlesTableView: UITableView!
    @IBOutlet weak var circleSearchBar: UISearchBar!
    
    // labels and filtered labels
    var groups : [Group]?
    var filteredGroups : [Group]?
    var contacts : [Contact]?
    let refreshControl = UIRefreshControl();
    
    // application layer
    let contactManager = ContactManager.sharedInstance
    let groupManager = GroupManager.sharedInstance
    
    var kbContactsController : KBContactsSelectionViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circlesTableView.dataSource = self
        circlesTableView.delegate = self
        circleSearchBar.delegate = self
        fetchGroups()
        setupKBContactsController()
        setupButton()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        circlesTableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchGroups()
    }
    
    func setupButton() {
        addButton.layer.cornerRadius = 48.0 / 2.0
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 1.0;
        addButton.layer.shadowRadius = 2.0
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
    }
    
    func buttonPressed() {
        self.createGroupName()
    }
    
    func fetchGroups() {
        self.groups = [Group]()
        circleSearchBar.text = ""
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        groupManager.allGroups(fetch: true, success: { (groups) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.groups = groups
                self.filteredGroups = groups
                self.circlesTableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                // @todo: show network error
                hud.hide(animated: true)
            }
        }
    }
    
    func setupKBContactsController() {
        kbContactsController = KBContactsSelectionViewController(configuration: { (config) in
            config?.shouldShowNavigationBar = true
            config?.title = Resources.Strings.Contacts.kNavigationBarTitle
            config?.selectButtonTitle = Resources.Strings.Contacts.kAddTaskNavItem
            config?.mode = KBContactsSelectionMode.messages
            config?.skipUnnamedContacts = true
            config?.customSelectButtonHandler = { (contacts : Any!) in
                if let contacts = contacts as? [APContact] {
                    self.contactsSelected(contacts:contacts)
                }
            }
            config?.contactEnabledValidation = { (contact : Any) in
                return true
            }
        })
    }
    
    func createGroupName(){
        UserDefaults.standard.removeObject(forKey: Resources.Strings.Groups.kNewCircleName)
        let alert = UIAlertController(title: Resources.Strings.Groups.kCircle, message: Resources.Strings.Groups.kNewCircleUserMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = ""
            textField.isSecureTextEntry = false
        })
        let saveAction = UIAlertAction(title: Resources.Strings.Groups.kCreate, style: UIAlertActionStyle.default) { action in
            if let textField = alert.textFields?[0], let text = textField.text {
                var groupName = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if groupName.characters.count > 0 {
                    UserDefaults.standard.set(groupName, forKey: Resources.Strings.Groups.kNewCircleName)
                    self.present(self.kbContactsController, animated: true, completion: nil)
                }
            }
        }
        
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func contactsSelected(contacts : [APContact]) {
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
        let group = Group()
        group.groupName = UserDefaults.standard.string(forKey: Resources.Strings.Groups.kNewCircleName) // change this to the one received above
        group.contacts = contactsArray
        
        groupManager.add(group: group, success: {
            self.fetchGroups()
        }) { (Error) in
            
        }
        
        kbContactsController.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let filteredGroups = filteredGroups {
            return filteredGroups.count;
        }
        else{
            return 0;
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let circleTableViewCell = circlesTableView.dequeueReusableCell(withIdentifier: Resources.Strings.Groups.kCircleTableViewCell, for: indexPath) as! CircleTableViewCell;
        let group = filteredGroups?[indexPath.row];
        let groupName = group?.groupName!;
        circleTableViewCell.groupNameLabel.text  = groupName;
        if let numberOfMembers = group?.contacts?.count {
            circleTableViewCell.numberOfMembers.text = String(describing: numberOfMembers)
        }
        
        return circleTableViewCell;
    }
    
    @IBAction func unwindToGroupsViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let circleMembersViewController = navigationController.viewControllers[0] as! CircleMembersViewController
        let indexPath = circlesTableView.indexPath(for: sender as! CircleTableViewCell)!
        circlesTableView.deselectRow(at: indexPath, animated:true)
        let group = self.groups![indexPath.row]
        circleMembersViewController.group = group;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyLabelFilter()
    }
    
    func applyLabelFilter() {
        guard var searchText = circleSearchBar.text else { return; }
        searchText = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if searchText.characters.count == 0 {
            filteredGroups = groups
            circlesTableView.reloadData()
            return;
        }
        
        filteredGroups = [Group]()
        for group in self.groups!
        {
            if (group.groupName?.lowercased().contains(searchText.lowercased()))!
            {
                self.filteredGroups?.append(group)
            }
        }
        circlesTableView.reloadData()
    }

}
