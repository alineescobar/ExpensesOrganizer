//
//  AddIncomeColectionViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 09/11/21.
//

import UIKit

class AddIncomeColectionViewController: UIViewController {
    
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

extension AddIncomeColectionViewController: UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 1.0, left: .zero, bottom: 1.0, right: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftPadding = collectionView.contentInset.left
        let rightPadding = collectionView.contentInset.right
        
        let itemsPerRow: CGFloat = 4
        let itemHeight: CGFloat = 87
        
        let totalPadding = leftPadding + rightPadding
        
        let availableWidth = collectionView.bounds.width - totalPadding
        
        let itemWidth = availableWidth / itemsPerRow

        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension AddIncomeColectionViewController: UICollectionViewDataSource {

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
