//
//  PlanningSelectionWalletViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 12/11/21.
//

import UIKit

class PlanningSelectionWalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var walletsCollectionView: UICollectionView!
    private let roundButtonID: String = "RoundButtonCollectionViewCell"
    @IBOutlet weak var pullIndicator: UIView!
    
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButtonCollectionViewCell
        cell?.categoryNameLabel.text = "Mirela"
        cell?.categoryNameLabel.textColor = .white
        cell?.background.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        cell?.tintColor = .white
        cell?.categoryImage.image = UIImage(systemName: "eyebrow")
        return cell ?? UICollectionViewCell()
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "planningDetail", sender: nil)
//    }
}
