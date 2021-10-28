//
//  ButtonsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 21/10/21.
//

import UIKit

protocol ButtonsCellDelegate: AnyObject {
    func didTapWalletButton()
    func didTapGoalsButton()
    func didTapPlanningButton()
    func didTapAddButton()
}

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var walletStackView: UIStackView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var goalsStackView: UIStackView!
    @IBOutlet weak var goalsView: UIView!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var planningStackView: UIStackView!
    @IBOutlet weak var planningView: UIView!
    @IBOutlet weak var planningLabel: UILabel!
    @IBOutlet weak var addStackView: UIStackView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    weak var buttonsDelegate: ButtonsCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        walletLabel.setAdjustableFontSize(scaleFactor: 0.2)
        goalsLabel.setAdjustableFontSize(scaleFactor: 0.2)
        planningLabel.setAdjustableFontSize(scaleFactor: 0.2)
        addLabel.setAdjustableFontSize(scaleFactor: 0.2)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        setCircles()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCircles()
        setShadows()
        setGestures()
        walletLabel.text = NSLocalizedString("WalletLabel", comment: "")
        goalsLabel.text = NSLocalizedString("GoalsLabel", comment: "")
        planningLabel.text = NSLocalizedString("PlanningLabel", comment: "")
        addLabel.text = NSLocalizedString("AddLabel", comment: "")
        layoutIfNeeded()
    }

    @objc
    func tapWalletButton(_ sender: UITapGestureRecognizer) {
        buttonsDelegate?.didTapWalletButton()
    }
    
    @objc
    func tapGoalsButton(_ sender: UITapGestureRecognizer) {
        buttonsDelegate?.didTapGoalsButton()
    }
    
    @objc
    func tapPlanningButton(_ sender: UITapGestureRecognizer) {
        buttonsDelegate?.didTapPlanningButton()
    }
    
    @objc
    func tapAddButton(_ sender: UITapGestureRecognizer) {
        buttonsDelegate?.didTapAddButton()
    }
    
    func setGestures() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapWalletButton(_:)))
        walletStackView.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGoalsButton(_:)))
        goalsStackView.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapPlanningButton(_:)))
        planningStackView.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAddButton(_:)))
        addStackView.addGestureRecognizer(tapGesture)
    }
    
    func setShadows() {
        walletView.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
        goalsView.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
        planningView.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
        addView.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
    }
    
    func setCircles() {
        walletView.layer.cornerRadius = walletView.frame.size.width / 2
        goalsView.layer.cornerRadius = goalsView.frame.size.width / 2
        planningView.layer.cornerRadius = planningView.frame.size.width / 2
        addView.layer.cornerRadius = addView.frame.size.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
