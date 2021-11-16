//
//  PlannimgPaymentTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 11/11/21.
//

import UIKit

class PlannimgPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var planningPaymentLabel: UILabel!
    
    @IBOutlet weak var planningPaymentWallet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // MARK: Planning payment label
        planningPaymentLabel.text = NSLocalizedString("PlanningCreationPayWith", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
