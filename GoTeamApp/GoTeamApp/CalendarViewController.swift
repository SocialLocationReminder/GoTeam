//
//  CalendarViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import JTCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarView: JTHorizontalCalendarView!
    
    let calendarManager = JTCalendarManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarManager.delegate = self
        calendarManager.contentView = calendarView
        calendarManager.menuView = calendarMenuView
        calendarManager.setDate(Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarViewController : JTCalendarDelegate {
    
}
