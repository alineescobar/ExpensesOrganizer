//
//  AddWalletCollectionViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 26/10/21.
//

import UIKit

class AddWalletCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
    
}
