//
//  PlanningIconTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 11/11/21.
//

import UIKit

class PlanningIconTableViewCell: UITableViewCell {

    @IBOutlet weak var planningIconLabel: UILabel!
    @IBOutlet weak var planningIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // MARK: Planning Icon label
        planningIconLabel.text = NSLocalizedString("PlanningCreationIcon", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
