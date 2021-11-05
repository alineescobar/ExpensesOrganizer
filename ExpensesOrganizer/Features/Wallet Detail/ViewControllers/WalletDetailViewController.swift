//
//  WalletDetailViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 26/10/21.
//

import UIKit

enum WalletDetailCategory: CaseIterable {
    case currency, description, planning, actionableCell, transaction
    
    static var allCases: [WalletDetailCategory] {
        return [.currency, .description, .planning, .actionableCell, .transaction, .transaction, .transaction, .transaction, .transaction]
    }
}

class WalletDetailViewController: UIViewController {
    private var walletRecentTransactions: [Transaction] = []
    private let customCellId = "TransactionCell"
    private let customCellHeader = "TransactionsHeaderCell"
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let walletDetailCategories: [WalletDetailCategory] = WalletDetailCategory.allCases
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var deleteWallet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction private func deleteWalletAction(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("WalletDeleteAlertTitle", comment: ""), message: NSLocalizedString("WalletDeleteAlertDescription", comment: ""), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { _ in
            // TODO: Delete Wallet object from CoreData
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))

        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.register(UINib(nibName: customCellHeader, bundle: nil), forCellReuseIdentifier: customCellHeader)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO: Make alert to make user know all inserted data will be lost
        super.viewWillDisappear(animated)
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

extension WalletDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let walletDetailCategory = walletDetailCategories[indexPath.row]
        
        switch walletDetailCategory {
        case .currency:
            return 81
        case .description:
            return 167
        case .planning:
            return 121
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let walletDetailCategory = walletDetailCategories[indexPath.row]
        
        switch walletDetailCategory {
        case .actionableCell:
            performSegue(withIdentifier: "transactions", sender: nil)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let walletDetailCategory = walletDetailCategories[indexPath.row]
        
        switch walletDetailCategory {
        case .transaction:
            return true
        default:
            return false
        }
    }
}

extension WalletDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walletDetailCategory = walletDetailCategories[indexPath.row]
        
        switch walletDetailCategory {
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
        case .actionableCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellHeader, for: indexPath) as? TransactionsHeaderCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            cell.transactionsDelegate = self
            return cell
        case .transaction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as? TransactionCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.transactionName.text = "Netflix"
            cell.transactionTag.text = "Assinatura"
            cell.transactionDate.text = "20 out"
            cell.transactionPrice.text = "-9,50"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletDetailCategories.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            walletRecentTransactions.remove(at: indexPath.row)
            // TODO: Update CoreData object
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension WalletDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension WalletDetailViewController: PlanningCellDelegate {
    func didTapRecurrency() {
        let storyboard = UIStoryboard(name: "WalletCreation", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "RecurrencyViewController") as? RecurrencyViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.recurrencyDelegate = self
        pvc?.selectedRecurrencyType = selectedRecurrencyType
        
        present(pvc ?? UIViewController(), animated: true)
    }
    
    func didTapCalendar() {
        let storyboard = UIStoryboard(name: "WalletCreation", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.calendarDelegate = self
        pvc?.selectedDate = selectedDate
        
        present(pvc ?? UIViewController(), animated: true)
    }
}

extension WalletDetailViewController: RecurrencyTypeDelegate {
    func sendRecurrencyType(recurrencyType: RecurrencyTypes) {
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
    }
}

extension WalletDetailViewController: CalendarDelegate {
    func sendDate(date: Date) {
        selectedDate = date
        tableView.reloadData()
    }
}

extension WalletDetailViewController: TransactionsHeaderDelegate {
    func didTapButton() {
        performSegue(withIdentifier: "transactions", sender: nil)
    }
}
