//
//  CircleMembersViewController.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class CircleMembersViewController: UIViewController {

    var group : Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = group?.groupName
        // Do any additional setup after loading the view.
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
