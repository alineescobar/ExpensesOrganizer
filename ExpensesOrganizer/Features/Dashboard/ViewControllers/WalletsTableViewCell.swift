//
//  WalletsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 25/10/21.
//

import UIKit

protocol WalletsCellDelegate: AnyObject {
    func didTapWallet(index: Int)
    func didTapAddWallet()
}

class WalletsTableViewCell: UITableViewCell {

    @IBOutlet weak var walletsCollectionView: UICollectionView!
    weak var walletsDelegate: WalletsCellDelegate?
    
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
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletCellID", for: indexPath) as? WalletCollectionViewCell
            cell?.balanceLabel.text = "$0"
            cell?.walletTitleLabel.text = "minha carteira"
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addWalletCellID", for: indexPath) as? AddWalletCollectionViewCell
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 168, height: 104)
        } else {
            return CGSize(width: 34, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            walletsDelegate?.didTapWallet(index: indexPath.row)
        } else {
            walletsDelegate?.didTapAddWallet()
        }
    }
}

extension WalletsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 24, bottom: 32, right: 20)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 20)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
