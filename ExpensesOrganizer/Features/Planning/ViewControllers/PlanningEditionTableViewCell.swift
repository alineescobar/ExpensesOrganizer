//
//  PlanningEditionTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 09/11/21.
//

import UIKit

protocol PlanningEditionDelegate: AnyObject {
    func didChangePlanningName(name: String)
    func didChangePlanningDescription(description: String)
}

class PlanningEditionTableViewCell: UITableViewCell {
    weak var planningEditionDelegate: PlanningEditionDelegate?
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var planningIcon: UIImageView!
    @IBOutlet weak var planningTitleTextField: UITextField!
    @IBOutlet weak var planningDescriptionTextField: UITextField!
    
    @IBAction private func planningTitleEditionAction(_ sender: UIButton) {
        planningTitleTextField.becomeFirstResponder()
    }
    @IBAction private func planningDescriptionEditionAction(_ sender: UIButton) {
        planningDescriptionTextField.becomeFirstResponder()
    }
    
    @IBAction private func didChangePlanningName(_ sender: UITextField) {
        planningEditionDelegate?.didChangePlanningName(name: sender.text ?? "")
    }
    
    @IBAction private func didChangePlanningDescription(_ sender: UITextField) {
        planningEditionDelegate?.didChangePlanningDescription(description: sender.text ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        planningTitleTextField.delegate = self
        planningDescriptionTextField.delegate = self
        circleView.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PlanningEditionTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
