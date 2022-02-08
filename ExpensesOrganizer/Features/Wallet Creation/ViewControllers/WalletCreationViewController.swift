//
//  WalletCreationViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 26/10/21.
//

import UIKit

protocol ModalHandlerDelegate: AnyObject {
    func modalDismissed()
}

enum WalletCreationCategory: CaseIterable {
    case currency, description, planning
    
    static var allCases: [WalletCreationCategory] {
        return [.currency, .description, .planning]
    }
}

class WalletCreationViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var walletBalance: Double = 0.0
    private var walletName: String = ""
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let walletCreationCategories: [WalletCreationCategory] = WalletCreationCategory.allCases
    @IBOutlet weak var newWalletLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var readyButton: UIButton!
    weak var modalHandlerDelegate: ModalHandlerDelegate?
    
    @IBAction private func readyAction(_ sender: UIButton) {
        // TODO: Create Wallet object on CoreData and verify data integrity
        if !walletBalance.isZero {
            guard let context = self.context else {
                return
            }
            
            let newWallet = Wallet(context: context)
            newWallet.name = walletName
            newWallet.value = walletBalance
            newWallet.recurrenceValue = walletBalance
            newWallet.walletID = UUID()
            newWallet.recurrenceDate = selectedDate
            newWallet.recurrencyType = selectedRecurrencyType.rawValue
            do {
                try context.save()
            } catch {
                showWalletSavingErrorAlert()
                return
            }
            self.dismiss(animated: true) {
                self.modalHandlerDelegate?.modalDismissed()
            }
        } else {
            showEmptyBalanceAlert()
        }
        
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        showCancelWalletAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        presentationController?.delegate = self
        isModalInPresentation = true
        tableView.delegate = self
        tableView.dataSource = self
        readyButton.setTitle(NSLocalizedString("Ready", comment: ""), for: .normal)
        newWalletLabel.text = NSLocalizedString("NewWallet", comment: "")
    }
    
    func showCancelWalletAlert() {
        let alert = UIAlertController(title: NSLocalizedString("WalletCreationCancelAlertTitle", comment: ""),
                                      message: NSLocalizedString("WalletCreationCancelAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("WalletCreationKeepCreatingAction", comment: ""), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showEmptyBalanceAlert() {
        let alert = UIAlertController(title: NSLocalizedString("EmptyBalanceAlertTitle", comment: ""),
                                      message: NSLocalizedString("EmptyBalanceAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showWalletSavingErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("WalletSavingErrorAlertTitle", comment: ""),
                                      message: NSLocalizedString("WalletSavingErrorAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
}

extension WalletCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let walletCreationCategory = walletCreationCategories[indexPath.row]
        
        switch walletCreationCategory {
        case .currency:
            return 81
        case .description:
            return 167
        case .planning:
            return 121
        }
    }
}

extension WalletCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walletCreationCategory = walletCreationCategories[indexPath.row]
        
        switch walletCreationCategory {
        case .currency:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell
            else {
                return UITableViewCell()
            }
            cell.currencyDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionTableViewCell
            else {
                return UITableViewCell()
            }
            cell.descriptionDelegate = self
            cell.descriptionTextField.placeholder = NSLocalizedString("WalletName", comment: "")
            cell.descriptionLabel.text = NSLocalizedString("Description", comment: "")
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningCell", for: indexPath) as? PlanningTableViewCell
            else {
                return UITableViewCell()
            }
            
            cell.planningDelegate = self
            cell.recurrencyLabel.text = RecurrencyTypes.getTitleFor(title: selectedRecurrencyType)
            
            let formatter = DateFormatter()
            let format = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale.current)
            formatter.dateFormat = format
            let date = formatter.string(from: selectedDate)
            cell.dateLabel.text = date
            cell.planningLabel.text = NSLocalizedString("Planning", comment: "")
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletCreationCategories.count
    }
    
}

extension WalletCreationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let viewController = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        viewController.heightMultiplier = 0.6
        return viewController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension WalletCreationViewController: PlanningCellDelegate {
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

extension WalletCreationViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showCancelWalletAlert()
    }
}

extension WalletCreationViewController: UIGestureRecognizerDelegate {
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

extension WalletCreationViewController: DescriptionDelegate {
    func descriptionDidChanged(description: String) {
        walletName = description.isEmpty ? "Principal" : description
    }
}

extension WalletCreationViewController: CurrencyDelegate {
    func currencyValueHasChanged(currency: Double) {
        walletBalance = currency
    }
}

extension WalletCreationViewController: RecurrencyTypeDelegate {
    func sendRecurrencyType(recurrencyType: RecurrencyTypes) {
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
    }
}

extension WalletCreationViewController: CalendarDelegate {
    func sendDate(date: Date) {
        selectedDate = date
        tableView.reloadData()
    }
}
