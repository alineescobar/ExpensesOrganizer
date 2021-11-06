//
//  AddIncomeValueCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddIncomeValueCell: UITableViewCell {
    static let identifier: String = "add-income-value-cell"
    
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet weak var backspaceButton: UIButton!
    
    @IBAction private func backspaceAction(_ sender: UIButton) {
        if var textFieldText = currencyTextField.text, !textFieldText.isEmpty {
            textFieldText.remove(at: textFieldText.index(before: textFieldText.endIndex))
            currencyTextField.text = textFieldText
            
            myTextFieldDidChange(currencyTextField)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        currencyTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    @objc
    func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = currencyTextField.text?.currencyInputFormatting() {
            currencyTextField.text = amountString
        }
    }
}
