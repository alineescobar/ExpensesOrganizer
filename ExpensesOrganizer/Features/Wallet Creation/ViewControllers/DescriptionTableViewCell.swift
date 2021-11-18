//
//  DescriptionTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 29/10/21.
//

import UIKit

protocol DescriptionDelegate: AnyObject {
    func descriptionDidChanged(description: String)
}

class DescriptionTableViewCell: UITableViewCell {
    weak var descriptionDelegate: DescriptionDelegate?
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imageTextFieldStackView: UIStackView!
    
    @IBAction private func didTextFieldEditingChanged(_ sender: UITextField) {
        descriptionDelegate?.descriptionDidChanged(description: sender.text ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextField.delegate = self
        descriptionLabel.textColor = UIColor(named: "TertiaryBrandColor")
        descriptionTextField.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        cellImageView.image?.withTintColor(UIColor(named: "TertiaryBrandColor") ?? UIColor.black)
        imageTextFieldStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        imageTextFieldStackView.isLayoutMarginsRelativeArrangement = true
        // Initialization code
    }

}

extension DescriptionTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
