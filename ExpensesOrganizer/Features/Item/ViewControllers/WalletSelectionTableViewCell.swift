//
//  WalletSelectionTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 10/11/21.
//

import UIKit

protocol WalletSelectionCellDelegate: AnyObject {
    func didTapWalletSelection()
}

class WalletSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var walletSelectionStackView: UIStackView!
    @IBOutlet weak var selectedWalletLabel: UILabel!
    @IBOutlet weak var walletImageView: UIImageView!
    weak var walletSelectionDelegate: WalletSelectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGestures()
        walletSelectionStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        walletSelectionStackView.isLayoutMarginsRelativeArrangement = true
    }

    @objc
    func tapWalletSelection(_ sender: UITapGestureRecognizer) {
        walletSelectionDelegate?.didTapWalletSelection()
    }
    
    func setGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapWalletSelection(_:)))
        walletSelectionStackView.addGestureRecognizer(tapGesture)
    }

}
