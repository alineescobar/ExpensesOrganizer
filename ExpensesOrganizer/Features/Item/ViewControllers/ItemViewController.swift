//
//  ItemViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 09/11/21.
//

import UIKit

enum ItemCategory: CaseIterable {
    case currency, description, wallet, planning
    
    static var allCases: [ItemCategory] {
        return [.currency, .description, .wallet, .planning]
    }
}

class ItemViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction private func cancelAction(_ sender: UIButton) {
    }
    @IBAction private func readyAction(_ sender: UIButton) {
    }
    
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let itemCategories: [ItemCategory] = ItemCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        
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
//        let itemCategory = itemCategories[indexPath.row]
//
//        switch itemCategory {
//        case .currency:
//            return 81
//        case .description:
//            return 167
//        case .planning:
//            return 121
//        }
        return UITableView.automaticDimension
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
            return cell
        
        case .wallet:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as? WalletSelectionTableViewCell
            else {
                return UITableViewCell()
            }
            cell.selectedWalletLabel.text = "Pagar com" // Change to localized string
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningCell", for: indexPath) as? PlanningTableViewCell
            else {
                return UITableViewCell()
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            cell.planningDelegate = self
            cell.recurrencyLabel.text = selectedRecurrencyType.rawValue
            cell.dateLabel.text = formatter.string(from: selectedDate)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCategories.count
    }
    
}

extension ItemViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
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
