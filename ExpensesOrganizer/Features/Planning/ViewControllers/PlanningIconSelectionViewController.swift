//
//  PlanningIconSelectionViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 12/11/21.
//
// swiftlint:disable line_length
import UIKit

protocol IconDelegate: AnyObject {
    func sendIcon(iconName: String)
}

class PlanningIconSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var pullIndicator: UIView!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    weak var iconDelegate: IconDelegate?
    private let roundButtonID: String = "RoundButonWithoutLabelCollectionViewCell"
    private let iconNames: [String] = ["AirplaneTakeoff", "Atom", "Bug", "Car", "FinnTheHuman", "FirstAid", "ForkKnife", "Gift", "GraduationCap", "HandbagSimple", "House", "Knife", "Martini", "MonitorPlay", "Receipt", "ShoppingCart", "SuitcaseSimple", "TrendUp", "TShirt", "Users"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollection()
        pullIndicator.layer.cornerRadius = pullIndicator.frame.height / 2

    }
    
    private func setUpCollection() {
        iconsCollectionView.register(UINib(nibName: roundButtonID, bundle: nil), forCellWithReuseIdentifier: roundButtonID)
        iconsCollectionView.delegate = self
        iconsCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0
        iconsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension PlanningIconSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 24.0, bottom: 1.0, right: 24.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButonWithoutLabelCollectionViewCell
        let name = iconNames[indexPath.row]
        cell?.background.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        cell?.tintColor = .white
        cell?.iconImage.image = UIImage(named: name)
        
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let iconName = iconNames[indexPath.item]
        iconDelegate?.sendIcon(iconName: iconName)
        dismiss(animated: true, completion: nil)
    }
}
// swiftlint:enable line_length
