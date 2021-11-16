//
//  PlanningViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit
//    swiftlint:disable line_length
class PlanningViewController: UIViewController, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var planningCollectionView: UICollectionView!
    private let roundButtonID: String = "RoundButtonCollectionViewCell"
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var newPlanningButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Navigation Visuals
        self.navigationItem.title = NSLocalizedString("PlanningTitle", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any]
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor(named: "TertiaryBrandColor")
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        
        // MARK: Collection View Settings
        setUpCollection()
        
        // MARK: Adding a new planning button
        newPlanningButton.backgroundColor = UIColor(named: "TertiaryBrandColor")
        newPlanningButton.layer.cornerRadius = 20
        newPlanningButton.setTitle(NSLocalizedString("AddButton", comment: ""), for: .normal)
        
        // MARK: Segmented Controls
        segmentedControl.setTitle(NSLocalizedString("FirstSegmentedControl", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("SecondSegmentedControl", comment: ""), forSegmentAt: 1)
        let fontNormal = UIFont(name: "WorkSans-Regular", size: 14)
        let fontBold = UIFont(name: "WorkSans-Medium", size: 14)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontNormal as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontBold as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .selected)

    }
    private func setUpCollection() {
        planningCollectionView.register(UINib(nibName: roundButtonID, bundle: nil), forCellWithReuseIdentifier: roundButtonID)
        planningCollectionView.delegate = self
        planningCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        planningCollectionView.setCollectionViewLayout(layout, animated: true)
    }
     
}

extension PlanningViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButtonCollectionViewCell
        cell?.categoryNameLabel.text = "Mirela"
        cell?.categoryImage.image = UIImage(systemName: "eyebrow")
        return cell ?? UICollectionViewCell()
    }
    
}

extension PlanningViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 24.0, bottom: 1.0, right: 24.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 87)
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
}

//    swiftlint:enable line_length
