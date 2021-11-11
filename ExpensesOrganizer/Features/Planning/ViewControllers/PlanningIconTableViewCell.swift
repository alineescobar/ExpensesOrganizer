//
//  PlanningIconTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 11/11/21.
//

import UIKit

class PlanningIconTableViewCell: UITableViewCell {

    @IBOutlet weak var planningIconLabel: UILabel!
    
    @IBOutlet weak var planningIconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
