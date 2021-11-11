//
//  PlannimgPaymentTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 11/11/21.
//

import UIKit

class PlannimgPaymentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var planningPaymentLabel: UILabel!
    
    @IBOutlet weak var planningPaymentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
