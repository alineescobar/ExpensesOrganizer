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
    @IBOutlet weak var textStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = NSLocalizedString("addition-expense-name", comment: "")
        nameTextField.placeholder = NSLocalizedString("addition-expense-name-placeholder", comment: "")
        
        textStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        textStack.isLayoutMarginsRelativeArrangement = true
    }
}
