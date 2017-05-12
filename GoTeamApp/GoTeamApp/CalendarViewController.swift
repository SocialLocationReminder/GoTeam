//
//  CalendarViewController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import JTCalendar
import ESTimePicker

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarView: JTHorizontalCalendarView!
    @IBOutlet weak var pickATimeView: UIView!
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var maskView: UIView!
    
    var annotationType : AnnotationType!
    
    var timePicker : ESTimePicker!
    
    let calendarManager = JTCalendarManager()
    var dateSelected : Date?
    var hourPicked : Int32?
    var minutesPicked : Int32?
    var timePicked = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    static let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarManager.delegate = self
        calendarManager.contentView = calendarView
        calendarManager.menuView = calendarMenuView
        calendarManager.setDate(Date())
        
        self.timeLabel.text = ""
        setupTimePickerView()
        setupMaskView()
        
        // pick today by default
        dateSelected = Date()
        updateDateLabel()
    }

    func setupTimePickerView() {
        timePickerView.isHidden = true
        timePickerView.layer.cornerRadius = timePickerView.frame.width / 2.0
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pickATimeTapped))
        pickATimeView.addGestureRecognizer(tapGR)
    }
    
    func setupMaskView() {
        let maskViewGR = UITapGestureRecognizer(target: self, action: #selector(maskViewTapped))
        maskView.addGestureRecognizer(maskViewGR)
        maskView.isHidden = true
        maskView.alpha = 0.6
        maskView.backgroundColor = UIColor.black
    }
    
    func pickATimeTapped(sender : UITapGestureRecognizer) {
        hourPicked = nil
        minutesPicked = nil
        timePicker = ESTimePicker(delegate: self)
        timePickerView.addSubview(timePicker)
        timePicker.frame = timePickerView.bounds
        timePickerView.isHidden = false
        maskView.isHidden = false
    }

    func maskViewTapped(sender : UITapGestureRecognizer) {
        hideTimePicker()
    }
    
    func hideTimePicker() {
        timePicker.removeFromSuperview()
        timePickerView.isHidden = true
        maskView.isHidden = true
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

extension CalendarViewController : ESTimePickerDelegate {
    func timePickerHoursChanged(_ timePicker: ESTimePicker!, toHours hours: Int32) {
        hourPicked = hours
        updateTimeLabel()
    }
    func timePickerMinutesChanged(_ timePicker: ESTimePicker!, toMinutes minutes: Int32) {
        if hourPicked == nil,
            let dateSelected = dateSelected {
            let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            let components = gregorian.dateComponents(in: TimeZone.current, from: dateSelected)
            if let hour = components.hour {
                hourPicked = Int32(hour)
            }
        }
        minutesPicked = minutes
        updateTimeLabel()
        timePicked = true
        hideTimePicker()
    }
    
    func updateTimeLabel() {
        if dateSelected == nil {
            dateSelected = Date()
        }
        let date = dateSelected!
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = gregorian.dateComponents(in: TimeZone.current, from: date)
        
        if let hourPicked = hourPicked {
            components.hour = Int(hourPicked)
        }
        if let minutesPicked = minutesPicked {
            components.minute = Int(minutesPicked)
        }
        
        if let date = gregorian.date(from: components) {
            dateSelected = date
            CalendarViewController.dateFormatter.dateFormat = "hh:mm a"
            timeLabel.text = CalendarViewController.dateFormatter.string(from: date)
        }
    }
}
