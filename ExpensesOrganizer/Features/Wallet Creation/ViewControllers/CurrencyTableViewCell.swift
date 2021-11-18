//
//  CurrencyTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 29/10/21.
//

import UIKit

protocol CurrencyDelegate: AnyObject {
    func currencyValueHasChanged(currency: Double)
}

class CurrencyTableViewCell: UITableViewCell {
    weak var currencyDelegate: CurrencyDelegate?
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var backspaceButton: UIButton!
    
    @IBAction private func backspaceAction(_ sender: UIButton) {
        if var textFieldText = currencyTextField.text {
            if textFieldText.isEmpty {
                return
            }
            textFieldText.remove(at: textFieldText.index(before: textFieldText.endIndex))
            currencyTextField.text = textFieldText
            myTextFieldDidChange(currencyTextField)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        currencyTextField.delegate = self
        currencyTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        currencyTextField.placeholder = String(format: "%.2f", 10.0).currencyInputFormatting()
        currencyTextField.textColor = UIColor(named: "TertiaryBrandColor")
        backspaceButton.tintColor = UIColor(named: "TertiaryBrandColor")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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

extension CurrencyTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
