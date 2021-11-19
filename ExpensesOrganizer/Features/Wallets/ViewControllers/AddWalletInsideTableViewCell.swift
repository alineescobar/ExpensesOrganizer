//
//  AddWalletInsideTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 04/11/21.
//

import UIKit

class AddWalletInsideTableViewCell: UITableViewCell {

    @IBOutlet weak var addWalletButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addWalletButton.layer.cornerRadius = 20
        addWalletButton.layer.masksToBounds = true
        
        addWalletButton.layer.shadowColor = UIColor.black.cgColor
        addWalletButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        addWalletButton.layer.shadowRadius = 2.0
        addWalletButton.layer.shadowOpacity = 0.2
        addWalletButton.layer.masksToBounds = false
        addWalletButton.titleLabel?.font = UIFont(name: "WorkSans-SemiBold", size: 16)
        addWalletButton.setTitle(NSLocalizedString("CreateNewWallet", comment: ""), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
