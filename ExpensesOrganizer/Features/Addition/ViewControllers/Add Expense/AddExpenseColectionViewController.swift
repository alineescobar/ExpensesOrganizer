//
//  AddExpenseColectionViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 11/11/21.
//

import CoreData
import Foundation
import UIKit

protocol ObjectSelectionDelegate: AnyObject {
    func didSelectObject(object: Any)
}

class AddExpenseColectionViewController: UIViewController {
    var collectionType: CollectionType = .templates
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var templates: [Template] = []
    private var wallets: [Wallet] = []
    weak var objectSelectionDelegate: ObjectSelectionDelegate?
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
        
        if collectionType == .wallets {
            fetchWallets()
        } else {
            fetchTemplates()
        }
    }
    
    func fetchTemplates() {
        guard let context = self.context else {
            return
        }
        
        do {
            let request = Template.fetchRequest() as NSFetchRequest<Template>
            let outcomePredicate = NSPredicate(format: "isExpense == %@", NSNumber(value: true))
            
            request.predicate = outcomePredicate
            templates = try context.fetch(request)
            templates.swapAt(templates.firstIndex(where: { $0.templateIconName == "Atom" }) ?? 0, templates.endIndex - 1)
            
        } catch {
            print("Erro ao carregar.")
        }
    }
    
    func fetchWallets() {
        guard let context = self.context else {
            return
        }
        
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
        } catch {
            print("Erro ao carregar.")
        }
    }
    
}

extension AddExpenseColectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionType == .wallets ? wallets.count : templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonCollectionCellID, for: indexPath) as? RoundButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.categoryNameLabel.text = collectionType == .wallets ? wallets[indexPath.row].name : templates[indexPath.row].name
        cell.categoryNameLabel.textColor = .white
        cell.background.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        cell.categoryImage.image = collectionType == .wallets ? UIImage(named: "Wallet") : UIImage(named: templates[indexPath.row].templateIconName ?? "Atom")
        cell.tintColor = .white

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        objectSelectionDelegate?.didSelectObject(object: collectionType == .wallets ? wallets[indexPath.row] : templates[indexPath.row])
        self.dismiss(animated: true)
    }
}
