//
//  AddWalletInsideTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 04/11/21.
//

import UIKit

class AddWalletInsideTableViewCell: UITableViewCell {

    @IBOutlet weak var addWalletButton: UIButton!
    
    weak var walletsDelegate: WalletsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addWalletButton.layer.cornerRadius = 8
        addWalletButton.layer.masksToBounds = true
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 0.2
//        self.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
