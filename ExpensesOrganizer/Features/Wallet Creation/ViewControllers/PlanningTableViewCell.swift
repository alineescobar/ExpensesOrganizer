//
//  PlanningTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 29/10/21.
//

import UIKit

protocol PlanningCellDelegate: AnyObject {
    func didTapRecurrency()
    func didTapCalendar()
}

class PlanningTableViewCell: UITableViewCell {

    @IBOutlet weak var recurrencyStackView: UIStackView!
    @IBOutlet weak var calendarStackView: UIStackView!
    @IBOutlet weak var planningLabel: UILabel!
    @IBOutlet weak var planningStackView: UIStackView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var recurrencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    weak var planningDelegate: PlanningCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGestures()
        planningStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        planningStackView.isLayoutMarginsRelativeArrangement = true
        // Initialization code
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
        recurrencyStackView.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCalendar(_:)))
        calendarStackView.addGestureRecognizer(tapGesture)
    }

}
