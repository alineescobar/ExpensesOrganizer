//
//  WalletsInsideTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 04/11/21.
//

import UIKit

class WalletsInsideTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceInsideLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var insideWalletButton: UIButton!
    @IBOutlet weak var walletInside: UIStackView!
    @IBOutlet weak var walletAllContrains: UIStackView!
    
    weak var walletsDelegate: WalletsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        walletInside.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        walletInside.isLayoutMarginsRelativeArrangement = true
        walletAllContrains.layer.cornerRadius = 8
        walletAllContrains.layer.masksToBounds = true
        
        walletAllContrains.layer.shadowColor = UIColor.black.cgColor
        walletAllContrains.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        walletAllContrains.layer.shadowRadius = 2.0
        walletAllContrains.layer.shadowOpacity = 0.2
        walletAllContrains.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
