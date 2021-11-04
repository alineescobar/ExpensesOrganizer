//
//  DescriptionTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 29/10/21.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var walletNameTextField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imageTextFieldStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageTextFieldStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        imageTextFieldStackView.isLayoutMarginsRelativeArrangement = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
