//
//  CircleMembersViewController.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class CircleMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var group : Group?
    var contacts : [Contact]?
    
    @IBOutlet weak var circleMembersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = group?.groupName
        contacts = group?.contacts
        
        circleMembersTableView.delegate = self
        circleMembersTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let contacts = contacts {
            return contacts.count;
        }
        else{
            return 0;
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let circleContactTableViewCell = circleMembersTableView.dequeueReusableCell(withIdentifier: "CircleContactTableViewCell", for: indexPath) as! CircleContactTableViewCell;
        let contact = contacts?[indexPath.row];
        let phone = contact?.phone
        let fullName = contact?.fullName
        circleContactTableViewCell.contactNameLabel.text  = fullName;
        circleContactTableViewCell.contactPhoneLabel.text  = phone;
        
        return circleContactTableViewCell
    }

}
