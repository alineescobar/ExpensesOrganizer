//
//  BalanceTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 21/10/21.
//

import UIKit

protocol BalanceCellDelegate: AnyObject {
    func didTapBalanceButton()
}

class BalanceTableViewCell: UITableViewCell {
    
    @IBAction private func hideBalanceAction(_ sender: UIButton) {
        balanceDelegate?.didTapBalanceButton()
    }
    
    @IBOutlet weak var hideBalanceButton: UIButton!
    @IBOutlet weak var balanceStackView: UIStackView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var showGraphicsImage: UIImageView!
    weak var balanceDelegate: BalanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideBalanceButton.setTitle(NSLocalizedString("BalanceLabel", comment: ""), for: .normal)
        hideBalanceButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBalance(_:)))
        balanceStackView.addGestureRecognizer(tapGesture)
        // Initialization code
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
