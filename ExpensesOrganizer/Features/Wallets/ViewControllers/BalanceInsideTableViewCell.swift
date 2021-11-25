//
//  BalanceInsideTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 29/10/21.
//

import UIKit

class BalanceInsideTableViewCell: UITableViewCell {

    @IBAction private func hideBalanceInsideAction(_ sender: UIButton) {
        balanceDelegate?.didTapBalanceButton()
    }
    
    @IBOutlet weak var atualBalance: UIButton!
    @IBOutlet weak var currentBalanceButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceInsideWalletConstrains: UIStackView!
    @IBOutlet weak var stackJustForBalance: UIStackView!
    weak var balanceDelegate: BalanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentBalanceButton.setTitle(NSLocalizedString("BalanceLabel", comment: ""), for: .normal)
        currentBalanceButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        atualBalance.titleLabel?.font = UIFont(name: "Work Sans", size: 14)
        balanceLabel.font = UIFont(name: "WorkSans-Bold", size: 48)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBalance(_:)))
        stackJustForBalance.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func tapBalance(_ sender: UITapGestureRecognizer) {
        balanceDelegate?.didTapBalanceButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
