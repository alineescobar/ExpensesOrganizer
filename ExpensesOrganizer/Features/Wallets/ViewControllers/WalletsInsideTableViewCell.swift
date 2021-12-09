//
//  WalletsInsideTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 04/11/21.
//

import UIKit

protocol WalletsInsideCellDelegate: AnyObject {
    func didTapWallet(index: Int)
}

class WalletsInsideTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceInsideLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var insideWalletButton: UIButton!
    @IBOutlet weak var walletInside: UIStackView!
    @IBOutlet weak var walletAllContrains: UIStackView!
    @IBOutlet weak var walletAllConstraintsView: UIView!
    var index: Int = 0
    
    @IBAction private func insideWalletAction(_ sender: UIButton) {
        walletsInsideCellDelegate?.didTapWallet(index: index)
    }
    
    weak var walletsInsideCellDelegate: WalletsInsideCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        walletInside.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        walletInside.isLayoutMarginsRelativeArrangement = true
        walletAllConstraintsView.layer.cornerRadius = 8
        walletAllConstraintsView.layer.masksToBounds = true
        
        walletAllConstraintsView.layer.shadowColor = UIColor.black.cgColor
        walletAllConstraintsView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        walletAllConstraintsView.layer.shadowRadius = 2.0
        walletAllConstraintsView.layer.shadowOpacity = 0.2
        walletAllConstraintsView.layer.masksToBounds = false
        
        walletAllContrains.layer.cornerRadius = 8
        walletAllContrains.layer.masksToBounds = true
        
        walletAllContrains.layer.shadowColor = UIColor.black.cgColor
        walletAllContrains.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        walletAllContrains.layer.shadowRadius = 2.0
        walletAllContrains.layer.shadowOpacity = 0.2
        walletAllContrains.layer.masksToBounds = true
        
        balanceInsideLabel.font = UIFont(name: "WorkSans-Bold", size: 20)
        walletNameLabel.font = UIFont(name: "Work Sans", size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
