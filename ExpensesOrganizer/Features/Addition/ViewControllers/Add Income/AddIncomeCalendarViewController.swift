//
//  AddIncomeCalendarViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 05/11/21.
//

import UIKit

class AddIncomeCalendarViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var containerView: UIView!
    weak var calendarDelegate: CalendarDelegate?
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setDate(selectedDate, animated: true)
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        containerView.layer.cornerRadius = 13
        overrideUserInterfaceStyle = .dark
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        calendarDelegate?.sendDate(date: datePicker.date)
    }
}
