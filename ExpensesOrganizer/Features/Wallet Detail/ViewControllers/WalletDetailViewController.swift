//
//  WalletDetailViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 26/10/21.
//

import UIKit

enum WalletDetailCategory: CaseIterable {
    case currency, description, planning, actionableCell
    
    static var allCases: [WalletDetailCategory] {
        return [.currency, .description, .planning, .actionableCell]
    }
}

class WalletDetailViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var walletBalance: Double = 0.0
    private var walletName: String = ""
    private var walletRecentTransactions: [Transaction] = []
    var wallet: Wallet?
    private let customCellId = "TransactionCell"
    private let customCellHeader = "TransactionsHeaderCell"
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let walletDetailCategories: [WalletDetailCategory] = WalletDetailCategory.allCases
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var deleteWallet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    weak var modalHandlerDelegate: ModalHandlerDelegate?
    
    @IBAction private func deleteWalletAction(_ sender: UIButton) {
        guard let context = self.context, let wallet = self.wallet else {
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("WalletDeleteAlertTitle", comment: ""), message: NSLocalizedString("WalletDeleteAlertDescription", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { _ in
            // TODO: Delete Wallet object from CoreData
            context.delete(wallet)
            do {
                try context.save()
                self.dismiss(animated: true)
            } catch {
                self.showWalletDeletingErrorAlert()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.register(UINib(nibName: customCellHeader, bundle: nil), forCellReuseIdentifier: customCellHeader)
        
        guard let wallet = self.wallet else {
            return
        }
        walletName = wallet.name ?? ""
        walletBalance = wallet.value
        walletNameLabel.text = wallet.name
        selectedDate = wallet.recurrenceDate ?? Date()
        selectedRecurrencyType = RecurrencyTypes(rawValue: wallet.recurrencyType ?? "Never") ?? RecurrencyTypes.never
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO: Make alert to make user know all inserted data will be lost
        super.viewWillDisappear(animated)
        guard let context = self.context, let wallet = self.wallet else {
            return
        }
        wallet.name = walletName
        wallet.value = walletBalance
        wallet.walletID = UUID()
        wallet.recurrenceDate = selectedDate
        wallet.recurrencyType = selectedRecurrencyType.rawValue
        do {
            try context.save()
        } catch {
            showWalletSavingErrorAlert()
            return
        }
        self.dismiss(animated: true) {
            self.modalHandlerDelegate?.modalDismissed()
        }
    }
    
    func showWalletSavingErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("WalletSavingErrorAlertTitle", comment: ""),
                                      message: NSLocalizedString("WalletSavingErrorAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showWalletDeletingErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("WalletDeletingErrorAlertTitle", comment: ""),
                                      message: NSLocalizedString("WalletDeletingErrorAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
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
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
}

extension WalletDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let wallet = self.wallet else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            let walletDetailCategory = walletDetailCategories[indexPath.row]
            
            switch walletDetailCategory {
            case .currency:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.currencyDelegate = self
                cell.currencyTextField.text = String(format: "%.2f", wallet.value).currencyInputFormatting()
                return cell
                
            case .description:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.descriptionDelegate = self
                cell.descriptionTextField.text = wallet.name
                cell.descriptionTextField.placeholder = NSLocalizedString("WalletName", comment: "")
                cell.descriptionLabel.text = NSLocalizedString("Description", comment: "")
                return cell
                
            case .planning:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningCell", for: indexPath) as? PlanningTableViewCell
                else {
                    return UITableViewCell()
                }
                let formatter = DateFormatter()
                let format = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale.current)
                formatter.dateFormat = format
                let date = formatter.string(from: selectedDate)
                
                cell.dateLabel.text = date
                cell.planningLabel.text = NSLocalizedString("Planning", comment: "")
                cell.planningDelegate = self
                cell.recurrencyLabel.text = RecurrencyTypes.getTitleFor(title: selectedRecurrencyType)
                
                return cell
            case .actionableCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellHeader, for: indexPath) as? TransactionsHeaderCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                
                cell.transactionsDelegate = self
                return cell
            }
        } else {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return walletDetailCategories.count
        } else {
            return walletRecentTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            walletRecentTransactions.remove(at: indexPath.row)
            // TODO: Update CoreData object
            //            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension WalletDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let viewController = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        viewController.heightMultiplier = 0.5
        return viewController
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

extension WalletDetailViewController: UIGestureRecognizerDelegate {
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

extension WalletDetailViewController: DescriptionDelegate {
    func descriptionDidChanged(description: String) {
        walletName = description.isEmpty ? "Principal" : description
    }
}

extension WalletDetailViewController: CurrencyDelegate {
    func currencyValueHasChanged(currency: Double) {
        walletBalance = currency
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
