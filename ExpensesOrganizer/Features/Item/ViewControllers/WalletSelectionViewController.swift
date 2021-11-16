//
//  WalletSelectionViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 10/11/21.
//

import UIKit

protocol WalletSelectionDelegate: AnyObject {
    func didTapWallet(wallet: Wallet)
}

class WalletSelectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let roundButtonID: String = "RoundButtonCollectionViewCell"
    weak var walletSelectionDelegate: WalletSelectionDelegate?
    private var wallets: [Wallet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Collection View Settings
        setUpCollection()
    }
    
    private func setUpCollection() {
        collectionView.register(UINib(nibName: roundButtonID, bundle: nil), forCellWithReuseIdentifier: roundButtonID)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WalletSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButtonCollectionViewCell
        cell?.categoryNameLabel.text = "Mirela"
        cell?.categoryImage.image = UIImage(systemName: "eyebrow")
        return cell ?? UICollectionViewCell()
    }
    
}

extension WalletSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 24.0, bottom: 1.0, right: 24.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 87)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Persist wallets data
//        walletSelectionDelegate?.didTapWallet(wallet: wallets[indexPath.row])
        self.dismiss(animated: true)
    }
}
