//
//  PlanningSelectionWalletViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 12/11/21.
//

import CoreData
import UIKit

protocol PlanningWalletSelectionDelegate: AnyObject {
    func sendWallet(wallet: Wallet)
}

class PlanningSelectionWalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var walletsCollectionView: UICollectionView!
    private let roundButtonID: String = "RoundButtonCollectionViewCell"
    @IBOutlet weak var pullIndicator: UIView!
    // swiftlint:disable identifier_name
    weak var planningWalletSelectionDelegate: PlanningWalletSelectionDelegate?
    // swiftlint:enable identifier_name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Collection View Settings
        setUpCollection()
        pullIndicator.layer.cornerRadius = pullIndicator.frame.height / 2
        
    }
    
    private func setUpCollection() {
        walletsCollectionView.register(UINib(nibName: roundButtonID, bundle: nil), forCellWithReuseIdentifier: roundButtonID)
        walletsCollectionView.delegate = self
        walletsCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        walletsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func fetchAllWallets() -> [Wallet] {
        var wallets = [Wallet()]
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return wallets
    }
}

extension PlanningSelectionWalletViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 24.0, bottom: 1.0, right: 24.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 87)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchAllWallets().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButtonCollectionViewCell
        let wallets = fetchAllWallets()
        
        cell?.categoryNameLabel.textColor = .white
        cell?.background.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        cell?.tintColor = .white
        
        if wallets.count < 1 {
            cell?.categoryNameLabel.text = "None"
            cell?.categoryImage.image = UIImage(named: "Wallet")
        } else {
            let allWallets = wallets[indexPath.row]
            cell?.categoryNameLabel.text = allWallets.name
            cell?.categoryImage.image = UIImage(named: "Wallet")
        }
        
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallets = fetchAllWallets()
        let wallet = wallets[indexPath.item]
        planningWalletSelectionDelegate?.sendWallet(wallet: wallet)
        dismiss(animated: true, completion: nil)
    }
}
// swiftlint:enable force_cast
