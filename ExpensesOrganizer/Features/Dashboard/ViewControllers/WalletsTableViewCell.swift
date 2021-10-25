//
//  WalletsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 25/10/21.
//

import UIKit

class WalletsTableViewCell: UITableViewCell {

    @IBOutlet weak var walletsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        walletsCollectionView.delegate = self
        walletsCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension WalletsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletCellID", for: indexPath) as? WalletCollectionViewCell
        cell?.balanceLabel.text = "$0"
        cell?.walletTitleLabel.text = "minha carteira"
        cell?.layer.cornerRadius = 8
        cell?.layer.masksToBounds = true
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 104)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedItemDelegate?.didSelectMusic(item: album!, music: music!)
    }
}

extension WalletsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 32, right: 20)
    }
}
