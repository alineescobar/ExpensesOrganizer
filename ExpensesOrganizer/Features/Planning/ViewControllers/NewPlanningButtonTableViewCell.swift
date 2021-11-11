//
//  NewPlanningButtonTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 11/11/21.
//

import UIKit

class NewPlanningButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var newPlanningButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // MARK:
//        newPlanningButton.backgroundColor = .black
//        newPlanningButton.layer.cornerRadius = 20
//        newPlanningButton.setTitle(NSLocalizedString("AddButton", comment: ""), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
