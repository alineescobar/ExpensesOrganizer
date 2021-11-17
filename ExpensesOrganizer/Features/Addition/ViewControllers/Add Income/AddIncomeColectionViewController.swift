//
//  AddIncomeColectionViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 09/11/21.
//

import UIKit

protocol IncomeCaterogyDelegate: AnyObject {
    func sendIncomeCategory (caterogy: Template)
}

class AddIncomeColectionViewController: UIViewController {
    // swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let roundButtonCollectionCellID: String = "RoundButtonCollectionViewCell"
    weak var incomeCategoryDelegate: IncomeCaterogyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollection()
    }
    
    func fetchAllCategories() -> [Template] {
        var categories = [Template()]
        do {
            categories = try context.fetch(Template.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return categories
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

extension AddIncomeColectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonCollectionCellID, for: indexPath) as? RoundButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.categoryNameLabel.text = "Mirela"
        cell.categoryNameLabel.textColor = .white
        cell.background.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        cell.categoryImage.image = UIImage(systemName: "eyebrow")
        cell.tintColor = .white

        return cell
    }
}

extension AddIncomeColectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 24.0, bottom: 1.0, right: 24.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 87)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categories = fetchAllCategories()
        let category = categories[indexPath.item]
        incomeCategoryDelegate?.sendIncomeCategory(caterogy: category)
        dismiss(animated: true, completion: nil)
    }
}
