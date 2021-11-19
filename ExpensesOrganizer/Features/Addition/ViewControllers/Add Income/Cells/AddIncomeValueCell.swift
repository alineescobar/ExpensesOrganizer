//
//  AddIncomeValueCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddIncomeValueCell: UITableViewCell {
    static let identifier: String = "add-income-value-cell"
    weak var currencyDelegate: CurrencyDelegate?
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
        currencyTextField.delegate = self
        currencyTextField.placeholder = String(format: "%.2f", 10.0).currencyInputFormatting()
        currencyTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    @objc
    func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = currencyTextField.text?.currencyInputFormatting() {
            currencyTextField.text = amountString
            var currencyWithoutCommas: String = currencyTextField.text?.replacingOccurrences(of: Locale.current.groupingSeparator ?? ",", with: "") ?? ""
            currencyWithoutCommas = currencyWithoutCommas.replacingOccurrences(of: Locale.current.decimalSeparator ?? ".", with: ".")
            currencyDelegate?.currencyValueHasChanged(currency: Double(currencyWithoutCommas) ?? 0.0)
        }
    }
}

extension AddIncomeValueCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
