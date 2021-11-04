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
        walletAllContrains.layer.cornerRadius = 20
        walletAllContrains.layer.masksToBounds = true
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 0.2
//        self.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
