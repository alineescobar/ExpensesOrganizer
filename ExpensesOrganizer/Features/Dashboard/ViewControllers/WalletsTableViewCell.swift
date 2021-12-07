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
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var wallets: [Wallet] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        walletsCollectionView.delegate = self
        walletsCollectionView.dataSource = self
        walletsCollectionView.backgroundColor = UIColor(named: "GraySuport3StateColor")
        
        fetchWallets()
    }
    
    func fetchWallets() {
        guard let context = self.context else {
            return
        }
        
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
        } catch {
            print("Erro ao carregar as carteiras.")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension WalletsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if wallets.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyStateID", for: indexPath) as? WalletEmptyStateCollectionViewCell
                return cell ?? UICollectionViewCell()
            }
            
            let wallet = wallets[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletCellID", for: indexPath) as? WalletCollectionViewCell
            let balance: Double = wallet.value
            cell?.balanceLabel.attributedText = getFormattedBalance(balance: balance, smallTextSize: 13.6, type: .card)
            cell?.walletTitleLabel.text = wallet.name
            
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addWalletCellID", for: indexPath) as? AddWalletCollectionViewCell
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return wallets.isEmpty ? 1 : wallets.count
        } else {
            return 1 // botao de +
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return wallets.isEmpty ? CGSize(width: 195, height: 104) : CGSize(width: 168, height: 104)
        } else {
            return CGSize(width: 34, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if wallets.isEmpty {
                return
            }
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
