//
//  PlanningTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 29/10/21.
//

import UIKit

class PlanningTableViewCell: UITableViewCell {

    @IBOutlet weak var planningLabel: UILabel!
    @IBOutlet weak var planningStackView: UIStackView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var recurrencyLabel: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        planningStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        planningStackView.isLayoutMarginsRelativeArrangement = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
