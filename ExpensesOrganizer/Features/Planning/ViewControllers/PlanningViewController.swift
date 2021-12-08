//
//  PlanningViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import CoreData
import UIKit

//    swiftlint:disable line_length
class PlanningViewController: UIViewController, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    @IBOutlet weak var planningCollectionView: UICollectionView!
    private let roundButtonID: String = "RoundButtonCollectionViewCell"
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var newPlanningButton: UIButton!
    private var incomeTemplates: [Template] = []
    private var outcomeTemplates: [Template] = []
    
    @IBAction private func didChangeOperationType(_ sender: UISegmentedControl) {
        planningCollectionView.reloadData()
    }
    
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
        newPlanningButton.backgroundColor = UIColor(named: "PrimaryBrandColor")
        newPlanningButton.layer.cornerRadius = 20
        newPlanningButton.setTitle(NSLocalizedString("AddButton", comment: ""), for: .normal)
        
        // MARK: Segmented Controls
        segmentedControl.setTitle(NSLocalizedString("FirstSegmentedControl", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("SecondSegmentedControl", comment: ""), forSegmentAt: 1)
        let fontNormal = UIFont(name: "WorkSans-Regular", size: 14)
        let fontBold = UIFont(name: "WorkSans-Semibold", size: 14)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontNormal as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontBold as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .selected)
        
        // MARK: Loading templates
        loadTemplates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
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
    
    private func loadTemplates() {
        guard let context = self.context else {
            return
        }
        do {
            let request = Template.fetchRequest() as NSFetchRequest<Template>
            let outcomePredicate = NSPredicate(format: "isExpense == %@", NSNumber(value: true))
            let incomePredicate = NSPredicate(format: "isExpense == %@", NSNumber(value: false))
            
            request.predicate = outcomePredicate
            outcomeTemplates = try context.fetch(request)
            outcomeTemplates.swapAt(outcomeTemplates.firstIndex(where: { $0.templateIconName == "Atom" }) ?? 0, outcomeTemplates.endIndex - 1)
            
            request.predicate = incomePredicate
            incomeTemplates = try context.fetch(request)
            incomeTemplates.swapAt(incomeTemplates.firstIndex(where: { $0.templateIconName == "Atom" }) ?? 0, incomeTemplates.endIndex - 1)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let index = sender as? Int else {
                let addNewPlanningViewController = segue.destination as? AddNewPlanningViewController
                addNewPlanningViewController?.modalHandlerDelegate = self
                return
            }
            
            if segmentedControl.selectedSegmentIndex == 0 {
                let planningDetailViewController = segue.destination as? PlanningDetailViewController
                planningDetailViewController?.template = outcomeTemplates[index]
                planningDetailViewController?.modalHandlerDelegate = self
            } else {
                let planningDetailViewController = segue.destination as? PlanningDetailViewController
                planningDetailViewController?.template = incomeTemplates[index]
                planningDetailViewController?.modalHandlerDelegate = self
            }
            
    }
    
}

extension PlanningViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return outcomeTemplates.count
        } else {
            return incomeTemplates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: roundButtonID, for: indexPath) as? RoundButtonCollectionViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let template = outcomeTemplates[indexPath.row]
            cell?.categoryNameLabel.text = template.name
            cell?.categoryImage.image = UIImage(named: template.templateIconName ?? "Atom")
            cell?.categoryImage.tintColor = UIColor(named: "TertiaryBrandColor")
            return cell ?? UICollectionViewCell()
        } else {
            let template = incomeTemplates[indexPath.row]
            cell?.categoryNameLabel.text = template.name
            cell?.categoryImage.image = UIImage(named: template.templateIconName ?? "Atom")
            return cell ?? UICollectionViewCell()
        }
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "planningDetail", sender: indexPath.row)
    }
}

extension PlanningViewController: ModalHandlerDelegate {
    func modalDismissed() {
        loadTemplates()
        planningCollectionView.reloadData()
        self.navigationItem.title = NSLocalizedString("PlanningTitle", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any]
    }
}
//    swiftlint:enable line_length
