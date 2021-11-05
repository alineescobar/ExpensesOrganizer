//
//  AEPlanningCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddExpensePlanningCell: UITableViewCell {
    static var identifier: String = "add-expense-planning-cell"
    
    @IBOutlet weak var recurrencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recurrencyStack: UIStackView!
    @IBOutlet weak var calendarStack: UIStackView!
    
    weak var planningDelegate: PlanningCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recurrencyStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        recurrencyStack.isLayoutMarginsRelativeArrangement = true
        
        setGestures()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func tapRecurrency(_ sender: UITapGestureRecognizer) {
        planningDelegate?.didTapRecurrency()
    }
    
    @objc
    func tapCalendar(_ sender: UITapGestureRecognizer) {
        planningDelegate?.didTapCalendar()
    }
    
    func setGestures() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecurrency(_:)))
        recurrencyStack.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCalendar(_:)))
        calendarStack.addGestureRecognizer(tapGesture)
    }
}
