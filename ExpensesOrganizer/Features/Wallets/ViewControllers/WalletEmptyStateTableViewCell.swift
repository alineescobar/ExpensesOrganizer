//
//  WalletEmptyStateTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 18/11/21.
//

import UIKit

class WalletEmptyStateTableViewCell: UITableViewCell {

//    @IBOutlet weak var walletInside: UIStackView!
    @IBOutlet weak var walletAllConstraintsView: UIView!
    @IBOutlet weak var walletAllConstrains: UIStackView!
    @IBOutlet weak var firstEmptyStateLabel: UILabel!
    @IBOutlet weak var secondEmptyStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstEmptyStateLabel.text = NSLocalizedString("FirstEmptyStateText", comment: "")
        secondEmptyStateLabel.text = NSLocalizedString("SecondEmptyStateWalletsText", comment: "")
        walletAllConstrains.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 16, right: 12)
        walletAllConstrains.isLayoutMarginsRelativeArrangement = true
        walletAllConstraintsView.layer.cornerRadius = 8
        walletAllConstraintsView.layer.masksToBounds = true
        
        walletAllConstraintsView.layer.shadowColor = UIColor.black.cgColor
        walletAllConstraintsView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        walletAllConstraintsView.layer.shadowRadius = 2.0
        walletAllConstraintsView.layer.shadowOpacity = 0.2
        walletAllConstraintsView.layer.masksToBounds = false
        
        walletAllConstrains.layer.cornerRadius = 8
        walletAllConstrains.layer.masksToBounds = true
        
        walletAllConstrains.layer.shadowColor = UIColor.black.cgColor
        walletAllConstrains.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        walletAllConstrains.layer.shadowRadius = 2.0
        walletAllConstrains.layer.shadowOpacity = 0.2
        walletAllConstrains.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
