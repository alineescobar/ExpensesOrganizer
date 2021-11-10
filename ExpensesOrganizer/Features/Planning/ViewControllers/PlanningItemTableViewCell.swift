//
//  PlanningItemTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 09/11/21.
//

import UIKit

protocol PlanningItemDelagate: AnyObject {
    func notificationSwitchDidChange(value: Bool, item: Item)
}

class PlanningItemTableViewCell: UITableViewCell {
    @IBAction private func didChangeSwitchValue(_ sender: UISwitch) {
        if let item = self.item {
            planningItemDelegate?.notificationSwitchDidChange(value: sender.isOn, item: item)
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var itemRecurrencyLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    weak var planningItemDelegate: PlanningItemDelagate?
    var item: Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
