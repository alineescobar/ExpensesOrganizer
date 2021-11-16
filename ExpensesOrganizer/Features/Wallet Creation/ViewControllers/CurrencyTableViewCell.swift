//
//  CurrencyTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 29/10/21.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet weak var backspaceButton: UIButton!
    
    @IBAction private func backspaceAction(_ sender: UIButton) {
        if var textFieldText = currencyTextField.text {
            if textFieldText.isEmpty {
                return
            }
           textFieldText.remove(at: textFieldText.index(before: textFieldText.endIndex))
            currencyTextField.text = textFieldText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        currencyTextField.delegate = self
        currencyTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = currencyTextField.text?.currencyInputFormatting() {
            currencyTextField.text = amountString
        }
    }

}

extension CurrencyTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
