//
//  AddWalletInsideCollectionViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 29/10/21.
//

import UIKit

class AddWalletInsideCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var createNewWalletButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
}
