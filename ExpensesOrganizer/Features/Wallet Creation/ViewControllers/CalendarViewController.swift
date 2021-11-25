//
//  CalendarViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 04/11/21.
//

import UIKit

protocol CalendarDelegate: AnyObject {
    func sendDate(date: Date)
}

class CalendarViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var calendarDelegate: CalendarDelegate?
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setDate(selectedDate, animated: true)
        containerView.layer.cornerRadius = 13
        overrideUserInterfaceStyle = .dark
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        calendarDelegate?.sendDate(date: datePicker.date)
        
    }
    
}

extension CalendarViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       pickerView.subviews[0].subviews[0].subviews[2].backgroundColor = pickerView.tintColor
        
    }
}
