//
//  AddIncomeNameCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddIncomeNameCell: UITableViewCell {
    static let identifier: String = "add-income-name-cell"
    weak var descriptionDelegate: DescriptionDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textStack: UIStackView!
    
    @IBAction private func didTextFieldEditingChanged(_ sender: UITextField) {
        descriptionDelegate?.descriptionDidChanged(description: sender.text ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        nameLabel.text = NSLocalizedString("addition-income-name", comment: "")
        nameTextField.placeholder = NSLocalizedString("addition-income-name-placeholder", comment: "")
        
        textStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        textStack.isLayoutMarginsRelativeArrangement = true
    }
}

extension AddIncomeNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
