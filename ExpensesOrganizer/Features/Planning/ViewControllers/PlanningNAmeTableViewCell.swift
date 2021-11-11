//
//  PlanningNAmeTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 11/11/21.
//

import UIKit

class PlanningNAmeTableViewCell: UITableViewCell {

    @IBOutlet weak var planningNameLabel: UILabel!
    @IBOutlet weak var planningNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // MARK: Name label
        planningNameLabel.text = NSLocalizedString("PlanningCreationPlanningName", comment: "")
        
        // MARK: Name text field
        planningNameTextField.placeholder = NSLocalizedString("PlanningCreationPlanningNamePlaceholder", comment: "")
        planningNameTextField.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
