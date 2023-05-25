//
//  CalendarViewController.swift
//  FIT3178-FinalMobileApp
//
//  Created by Max Coustley on 22/5/2023.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource	 {

    @IBOutlet weak var calendarView: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.appearance.todayColor = .systemBlue
        calendarView.appearance.titleTodayColor = .white
        
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let currentDate = Date()
        let calendar = Calendar.current
        let isPastDate = calendar.compare(date, to: currentDate, toGranularity: .day) == .orderedAscending
        
        if isPastDate {
            cell.titleLabel.textColor = UIColor.red // Set the color for past dates
        } else {
            cell.titleLabel.textColor = UIColor.black // Set the default color for other dates
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


