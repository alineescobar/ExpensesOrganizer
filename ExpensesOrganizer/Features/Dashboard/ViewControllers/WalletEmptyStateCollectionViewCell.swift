//
//  WalletEmptyStateCollectionViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 18/11/21.
//

import UIKit

class WalletEmptyStateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstEmptyStateLabel: UILabel!
    @IBOutlet weak var secondEmptyStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        
        firstEmptyStateLabel.text = NSLocalizedString("FirstEmptyStateText", comment: "")
        secondEmptyStateLabel.text = NSLocalizedString("SecondEmptyStateText", comment: "")
    }
}
