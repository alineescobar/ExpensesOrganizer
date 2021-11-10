//
//  AddExpenseNameTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddExpenseNameCell: UITableViewCell {
    static var identifier: String = "add-expense-name-cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = NSLocalizedString("addition-expense-name", comment: "")
        nameTextField.placeholder = NSLocalizedString("addition-expense-name-placeholder", comment: "")
    }
}
