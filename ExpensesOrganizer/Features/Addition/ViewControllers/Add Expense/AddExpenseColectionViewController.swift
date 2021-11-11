//
//  AddExpenseColectionViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 11/11/21.
//

import Foundation

import UIKit

class AddExpenseColectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let roundButtonCollectionCellID: String = "RoundButtonCollectionViewCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollection()
    }
    
    func setUpCollection() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collection-cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.register(UINib(nibName: roundButtonCollectionCellID, bundle: nil),
                                forCellWithReuseIdentifier: roundButtonCollectionCellID)
    }
}

extension AddExpenseColectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonCollectionCellID, for: indexPath) as? RoundButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.categoryNameLabel.text = "Mirela"
        cell.categoryImage.image = UIImage(systemName: "eyebrow")

        return cell
    }
}

extension AddExpenseColectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 24.0, bottom: 1.0, right: 24.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 87)
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "planningDetail", sender: nil)
//    }
}
