//
//  ItemViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 09/11/21.
//

import UIKit

protocol ItemDelegate: AnyObject {
    func updateItem()
}

enum ItemCategory: CaseIterable {
    case currency, description, wallets, planning
    
    static var allCases: [ItemCategory] {
        return [.currency, .description, .wallets, .planning]
    }
}

class ItemViewController: UIViewController {
    @IBOutlet weak var navigationBarStackView: UIStackView!
    @IBOutlet weak var conclusionView: UIView!
    @IBOutlet weak var firstConclusionLabel: UILabel!
    @IBOutlet weak var secondConclusionLabel: UILabel!
    @IBOutlet weak var readyConclusionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction private func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction private func readyAction(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState]) {
            self.navigationBarStackView.alpha = 0
            self.tableView.alpha = 0
            self.conclusionView.alpha = 1
        }
        itemDelegate?.updateItem()
    }
    @IBAction private func readyConclusionAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    var isEditingItem: Bool = false
    var item: Item?
    weak var itemDelegate: ItemDelegate?
    private var selectedWallet: Wallet?
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let itemCategories: [ItemCategory] = ItemCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        readyButton.setTitle(NSLocalizedString("Ready", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        conclusionView.alpha = 0
        firstConclusionLabel.text = NSLocalizedString("AllRight", comment: "")
        secondConclusionLabel.text = isEditingItem ? NSLocalizedString("UpdatedItem", comment: "") : NSLocalizedString("NewItemCreated", comment: "")
        readyConclusionButton.setTitle(NSLocalizedString("OKConfirmation", comment: ""), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update item on CoreData
        itemDelegate?.updateItem()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemCategory = itemCategories[indexPath.row]

        switch itemCategory {
        case .currency:
            return 81
        case .description:
            return 167
        case .wallets:
            return 121
        case .planning:
            return 121
        }
    }
}

extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCategory = itemCategories[indexPath.row]
        
        switch itemCategory {
        case .currency:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
            
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionTableViewCell
            else {
                return UITableViewCell()
            }
            cell.descriptionLabel.text = NSLocalizedString("ItemName", comment: "")
            return cell
        
        case .wallets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as? WalletSelectionTableViewCell
            else {
                return UITableViewCell()
            }
            cell.payWithLabel.text = NSLocalizedString("PayWith", comment: "")
            cell.walletSelectionDelegate = self
            cell.selectedWalletLabel.text = selectedWallet?.name ?? "No meu bolso"
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningCell", for: indexPath) as? PlanningTableViewCell
            else {
                return UITableViewCell()
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let date = formatter.string(from: selectedDate)
            
            cell.dateLabel.text = date.substring(toIndex: date.count - 4)
            cell.planningDelegate = self
            cell.planningLabel.text = NSLocalizedString("Planning", comment: "")
            cell.recurrencyLabel.text = RecurrencyTypes.getTitleFor(title: selectedRecurrencyType)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCategories.count
    }
    
}

extension ItemViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard let viewTitle = presented.title else {
            return UIPresentationController(presentedViewController: presented, presenting: presentingViewController)
        }
        
        let viewController = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        
        if viewTitle == "Calendar" || viewTitle == "Recurrency" {
            viewController.heightMultiplier = 0.5
        } else {
            // TODO: Make a logic that sets the height depending on the number of wallets
            viewController.heightMultiplier = 0.35
        }
            return viewController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension ItemViewController: PlanningCellDelegate {
    func didTapRecurrency() {
        let storyboard = UIStoryboard(name: "Item", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "RecurrencyViewController") as? RecurrencyViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.recurrencyDelegate = self
        pvc?.selectedRecurrencyType = selectedRecurrencyType
        
        present(pvc ?? UIViewController(), animated: true)
    }
    
    func didTapCalendar() {
        let storyboard = UIStoryboard(name: "Item", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.calendarDelegate = self
        pvc?.selectedDate = selectedDate
        
        present(pvc ?? UIViewController(), animated: true)
    }
}

extension ItemViewController: WalletSelectionCellDelegate {
    func didTapWalletSelection() {
        let storyboard = UIStoryboard(name: "Item", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "WalletSelectionViewController") as? WalletSelectionViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.walletSelectionDelegate = self
        
        present(pvc ?? UIViewController(), animated: true)
    }
}

extension ItemViewController: UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ItemViewController: RecurrencyTypeDelegate {
    func sendRecurrencyType(recurrencyType: RecurrencyTypes) {
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
    }
}

extension ItemViewController: CalendarDelegate {
    func sendDate(date: Date) {
        selectedDate = date
        tableView.reloadData()
    }
}

extension ItemViewController: WalletSelectionDelegate {
    func didTapWallet(wallet: Wallet) {
        selectedWallet = wallet
        tableView.reloadData()
    }
}
