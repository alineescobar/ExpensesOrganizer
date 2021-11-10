//
//  AddIncomeNameCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddIncomeNameCell: UITableViewCell {
    static let identifier: String = "add-income-name-cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = NSLocalizedString("addition-income-name", comment: "")
        nameTextField.placeholder = NSLocalizedString("addition-income-name-placeholder", comment: "")
    }
}
