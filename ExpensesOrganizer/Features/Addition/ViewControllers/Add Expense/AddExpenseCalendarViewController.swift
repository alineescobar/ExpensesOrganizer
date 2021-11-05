//
//  AddExpenseCalendarViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 05/11/21.
//

import UIKit

class AddExpenseCalendarViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var calendarDelegate: CalendarDelegate?
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setDate(selectedDate, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        calendarDelegate?.sendDate(date: datePicker.date)
    }
}
