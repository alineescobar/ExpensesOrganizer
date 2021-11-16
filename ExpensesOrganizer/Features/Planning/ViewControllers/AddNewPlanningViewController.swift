//
//  AddNewPlanningViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 10/11/21.
//

import UIKit
//    swiftlint:disable line_length
enum NewPlanningCategories: CaseIterable {
    case name, payment, icon, button
    
    static var allCases: [NewPlanningCategories] {
        return [.name, .payment, .icon, .button]
    }
}

class AddNewPlanningViewController: UIViewController, UITableViewDelegate {
    // swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private var selectedIcon: String = "Atom"
    private var selectedWallet: Wallet?
    private let newPlanningCategories: [NewPlanningCategories] = NewPlanningCategories.allCases
    private let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // MARK: Navigation Visuals
        self.navigationItem.title = NSLocalizedString("AddPlanningTitle", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any]
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor(named: "TertiaryBrandColor")
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        
        // MARK: Segmented Control
        segmentedControl.setTitle(NSLocalizedString("FirstSegmentedControl", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("SecondSegmentedControl", comment: ""), forSegmentAt: 1)
        let fontNormal = UIFont(name: "WorkSans-Regular", size: 14)
        let fontBold = UIFont(name: "WorkSans-Medium", size: 14)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontNormal as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontBold as Any, NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .selected)
        
        // MARK: Cancel button
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor(named: "GraySuport1StateColor")?.cgColor
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
        // MARK: Done button
        doneButton.layer.cornerRadius = 8
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = UIColor(named: "PrimaryBrandColor")?.cgColor
        doneButton.backgroundColor = UIColor(named: "PrimaryBrandColor")
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        doneButton.tintColor = .white
    }
    
    @IBAction private func newPlanningButton(_ sender: Any) {
        performSegue(withIdentifier: "item", sender: nil)
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchAllWallets() -> [Wallet] {
        var wallets = [Wallet()]
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return wallets
    }
}

extension AddNewPlanningViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPlanningCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newPlanningCategory = newPlanningCategories[indexPath.row]
        
        switch newPlanningCategory {
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningName", for: indexPath) as? PlanningNAmeTableViewCell
                    
            else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
        case .payment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningPayment", for: indexPath) as? PlannimgPaymentTableViewCell
            else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none

            cell.planningPaymentWallet.text = selectedWallet?.name == nil ? NSLocalizedString("WalletName", comment: "") : selectedWallet?.name
            return cell
            
        case .icon:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningIcon", for: indexPath) as? PlanningIconTableViewCell
            else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.planningIcon.image = UIImage(named: selectedIcon)
            cell.planningIcon.tintColor = UIColor(named: "TertiaryBrandColor")
            return cell
            
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newItenButton", for: indexPath) as? NewPlanningButtonTableViewCell
            else {
                return UITableViewCell()
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newPlanningCategory = newPlanningCategories[indexPath.row]
        
        switch newPlanningCategory {
        case .name:
            return 126
        case .payment:
            return 126
        case .icon:
            return 126
        case .button:
            return 81
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = indexPath.row
        
        if indexPath == 1 {
            let allWallets = fetchAllWallets()
            if allWallets.count < 1 {
                let alert = UIAlertController(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("message", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "AddNewPlanning", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "WalletSelection") as? PlanningSelectionWalletViewController
                pvc?.modalPresentationStyle = .custom
                pvc?.transitioningDelegate = self
                pvc?.planningWalletSelectionDelegate = self
                present(pvc ?? UIViewController(), animated: true)
            }
        } else if indexPath == 2 {
            let storyboard = UIStoryboard(name: "AddNewPlanning", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "iconsSelection") as? PlanningIconSelectionViewController
            pvc?.modalPresentationStyle = .custom
            pvc?.transitioningDelegate = self
            pvc?.iconDelegate = self
            present(pvc ?? UIViewController(), animated: true)
        }
    }
}

extension AddNewPlanningViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let viewController = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        
        if presented is PlanningSelectionWalletViewController {
            viewController.heightMultiplier = 0.40
        } else if presented is PlanningIconSelectionViewController {
            viewController.heightMultiplier = 0.60
        }
        
        return viewController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension AddNewPlanningViewController: IconDelegate {
    func sendIcon(iconName: String) {
        selectedIcon = iconName
        tableView.reloadData()
    }
}

extension AddNewPlanningViewController: PlanningWalletSelectionDelegate {
    
    func sendWallet(wallet: Wallet) {
        selectedWallet = wallet
        tableView.reloadData()
    }
}
//    swiftlint:enable line_length
