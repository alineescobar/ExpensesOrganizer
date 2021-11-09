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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
