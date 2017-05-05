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
    var dateSelected : Date?
    
    @IBOutlet weak var dateLabel: UILabel!
    static let dateFormatter = DateFormatter()
    
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
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        let dayView = dayView as! JTCalendarDayView
        dayView.isHidden = false
        if dayView.isFromAnotherMonth {
            dayView.isHidden = true
        }
        
        // Today
        
        else if calendarManager.dateHelper.date(Date(), isTheSameDayThan: dayView.date) {
            dayView.circleView.isHidden = false
            dayView.circleView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            dayView.dotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            dayView.textLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
            
        // Selected date
        else if let dateSelected = dateSelected, calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: dayView.date) {
            dayView.circleView.isHidden = false
            dayView.circleView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.4392156863, blue: 0.4039215686, alpha: 1)
            dayView.dotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            dayView.textLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        
        // Another day of the current month
        else {
            dayView.circleView.isHidden = true
            dayView.dotView.backgroundColor = #colorLiteral(red: 0.8166515231, green: 0.1429720223, blue: 0.0815751031, alpha: 1)
            dayView.textLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let dayView = dayView as! JTCalendarDayView
        dateSelected = dayView.date
        
        // animation for the circle view
        dayView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        UIView.transition(with: dayView, duration: 0.3, options: [], animations: {
            dayView.circleView.transform = CGAffineTransform.identity
            }, completion: nil)
        
        
        // Load the previous or next page if touch a day from another month
        if !calendarManager.dateHelper.date(calendarView.date, isTheSameMonthThan: dayView.date) {
            if calendarView.date.compare(dayView.date) == .orderedAscending {
                calendarView.loadNextPageWithAnimation()
            } else {
                calendarView.loadPreviousPageWithAnimation()
            }
        }
        
        updateDateLabel()
        calendarManager.reload()
    }
    
    func updateDateLabel() {
        if let dateSelected = dateSelected {
            CalendarViewController.dateFormatter.dateFormat = "MMMM d yyyy"
            dateLabel.text = CalendarViewController.dateFormatter.string(from: dateSelected)
        }
    }
}
