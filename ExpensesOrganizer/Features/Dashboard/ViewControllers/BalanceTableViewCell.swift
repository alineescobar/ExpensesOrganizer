//
//  BalanceTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 21/10/21.
//

import UIKit

protocol BalanceCellDelegate: AnyObject {
    func didTapBalanceButton()
    func didTapGraphicsButton()
}

class BalanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hideBalanceButton: UIButton!
    
    @IBAction private func hideBalanceAction(_ sender: UIButton) {
        balanceDelegate?.didTapBalanceButton()
    }
    @IBAction private func showGraphicsAction(_ sender: UIButton) {
        balanceDelegate?.didTapGraphicsButton()
    }
    
    @IBOutlet weak var balanceStackView: UIStackView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var balanceRoundedLabel: UILabel!
    @IBOutlet weak var balanceDecimalLabel: UILabel!
    @IBOutlet weak var showGraphicsButton: UIButton!
    weak var balanceDelegate: BalanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideBalanceButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
