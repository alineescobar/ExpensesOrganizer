//
//  PlanningViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

class PlanningViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var planningCollectionView: UICollectionView!
    private let roundButtonID: String = "RoundButtonCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
// MARK: Navigation Visuals
        self.navigationItem.title = "Planejar"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any]
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        
// MARK: Collection View Settings
        setUpCollection()
    }
    private func setUpCollection() {
        planningCollectionView.register(UINib(nibName: roundButtonID, bundle: nil), forCellWithReuseIdentifier: roundButtonID)
        planningCollectionView.delegate = self
        planningCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
             layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 55
        layout.minimumInteritemSpacing = 20
        planningCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension PlanningViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButtonCollectionViewCell
        return cell ?? UICollectionViewCell()
    }

}

extension PlanningViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return UIEdgeInsets(top: 1.0, left: 40.0, bottom: 1.0, right: 40.0)
        }

        func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
            //    swiftlint:disable force_cast
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            //    swiftlint:enable force_cast
//            let widthPerItem = collectionView.frame.width / 4 - lay.minimumInteritemSpacing
            
            return CGSize(width: 56, height: 56)
        }
}
