//
//  AddExpenseTableViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import CoreData
import UIKit

enum AddExpenseCells: CaseIterable {
    case value, divider, name, category, paymentMethod, planning
    
    static var allCases: [AddExpenseCells] {
        [.value, .name, .divider, .category, .divider, .paymentMethod, .divider, .planning]
    }
}

class AddExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    weak var modalHandlerDelegate: ModalHandlerDelegate?
    private var expenseName: String = ""
    private var expenseValue: Double = 0.0
    private var selectedWallet: Wallet?
    private var selectedTemplate: Template?
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let walletCreationCategories: [WalletCreationCategory] = WalletCreationCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        doneButton.layer.cornerRadius = 8
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        
        cancellButton.layer.cornerRadius = 8
        cancellButton.layer.borderColor = UIColor(named: "GraySuport1StateColor")?.cgColor
        cancellButton.layer.borderWidth = 2.0
        cancellButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
        hideKeyboardWhenTappedAround()
        
        guard let context = self.context else {
            return
        }
        
        do {
            var templates: [Template] = try context.fetch(Template.fetchRequest())
            templates.swapAt(templates.firstIndex(where: { $0.templateIconName == "Atom" }) ?? 0, templates.endIndex - 1)
            selectedTemplate = templates.last
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "open-income-alldone-segue" {
            let addExpenseDoneViewController = segue.destination as? AddExpenseAllDoneViewController
            addExpenseDoneViewController?.modalHandlerDelegate = self
        }
    }
    
    @IBAction private func cancellButton(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneAction(_ sender: UIButton) {
        if !expenseValue.isZero && selectedWallet != nil {
            guard let context = self.context else {
                return
            }
            
            let newTransaction = Transaction(context: context)
            newTransaction.name = expenseName
            newTransaction.value = expenseValue
            newTransaction.transactionDate = selectedDate
            newTransaction.recurrenceType = selectedRecurrencyType.rawValue
            newTransaction.category = selectedTemplate
            newTransaction.transactionDestination = selectedWallet?.walletID
            newTransaction.origin = nil
            newTransaction.outcome(objectID: selectedWallet?.walletID, value: expenseValue)
            
            do {
                let request = Item.fetchRequest() as NSFetchRequest<Item>
                let namePredicate = NSPredicate(format: "name == %@", expenseName)
                let templateIDPredicate = NSPredicate(format: "template.templateID == %@", selectedTemplate?.templateID?.uuidString ?? "")
                
                request.fetchLimit = 1
                
                request.predicate = NSCompoundPredicate(
                    andPredicateWithSubpredicates: [
                        namePredicate,
                        templateIDPredicate
                    ]
                )
                let items: [Item] = try context.fetch(request)
                if items.isEmpty {
                    let newItem = Item(context: context)
                    newItem.name = expenseName.isEmpty ? NSLocalizedString("Transaction", comment: "") : expenseName
                    newItem.value = expenseValue
                    newItem.paymentMethod = selectedWallet
                    newItem.recurrenceDate = selectedDate
                    newItem.template = selectedTemplate
                    newItem.sendsNotification = false
                    newItem.recurrenceType = selectedRecurrencyType.rawValue
                } else {
                    let item: Item? = items.first
                    item?.value = expenseValue
                    item?.recurrenceDate = selectedDate
                    item?.recurrenceType = selectedRecurrencyType.rawValue
                    item?.paymentMethod = selectedWallet
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                try context.save()
                performSegue(withIdentifier: "open-expense-alldone-segue", sender: nil)
            } catch {
                print(error.localizedDescription)
                return
            }
        } else if expenseValue.isZero && selectedWallet == nil {
            showEmptyWalletAndBalanceAlert()
        } else if expenseValue.isZero {
            showEmptyBalanceAlert()
        } else {
            showEmptyWalletAlert()
        }
    }
    
    func showEmptyBalanceAlert() {
        let alert = UIAlertController(title: NSLocalizedString("EmptyTransactionBalanceAlertTitle", comment: ""),
                                      message: NSLocalizedString("EmptyTransactionBalanceAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showEmptyWalletAlert() {
        let alert = UIAlertController(title: NSLocalizedString("EmptyTransactionWalletAlertTitle", comment: ""),
                                      message: NSLocalizedString("EmptyTransactionWalletAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showEmptyWalletAndBalanceAlert() {
        let alert = UIAlertController(title: NSLocalizedString("EmptyTransactionWalletBalanceAlertTitle", comment: ""),
                                      message: NSLocalizedString("EmptyTransactionWalletBalanceAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
}

extension AddExpenseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddExpenseCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCategory = AddExpenseCells.allCases[indexPath.row]
        
        switch cellCategory {
        case .value:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseValueCell.identifier, for: indexPath) as? AddExpenseValueCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            cell.currencyDelegate = self
            
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseNameCell.identifier, for: indexPath) as? AddExpenseNameCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            cell.descriptionDelegate = self
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseCategoryCell.identifier, for: indexPath) as? AddExpenseCategoryCell else {
                return UITableViewCell()
            }
            cell.selectionLabel.text = selectedTemplate?.name ?? NSLocalizedString("Others", comment: "")
            cell.selectionImage.image = UIImage(named: selectedTemplate?.templateIconName ?? "Atom")
            cell.planningDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .paymentMethod:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpensePaymentCell.identifier, for: indexPath) as? AddExpensePaymentCell else {
                return UITableViewCell()
            }
            cell.contentLabel.text = selectedWallet?.name ?? NSLocalizedString("WalletName", comment: "")
            cell.planningDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpensePlanningCell.identifier, for: indexPath) as? AddExpensePlanningCell else {
                return UITableViewCell()            }
            
            let formatter = DateFormatter()
            let format = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale.current)
            formatter.dateFormat = format
            let date = formatter.string(from: selectedDate)
            
            cell.dateLabel.text = date
            cell.planningDelegate = self
            cell.recurrencyLabel.text = RecurrencyTypes.getTitleFor(title: selectedRecurrencyType)
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .divider:
            return tableView.dequeueReusableCell(withIdentifier: "add-expense-divider-cell", for: indexPath)
        }
    }
}

extension AddExpenseViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        
        if presented is AddExpenseColectionViewController {
            presentationController.heightMultiplier = 0.43
        } else {
            presentationController.heightMultiplier = 0.6
        }
        
        return presentationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension AddExpenseViewController: PlanningCellDelegate, RecurrencyTypeDelegate, CalendarDelegate, CollectionDelegate,
                                    ObjectSelectionDelegate, CurrencyDelegate, DescriptionDelegate, ModalHandlerDelegate {
    
    func modalDismissed() {
        modalHandlerDelegate?.modalDismissed()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func descriptionDidChanged(description: String) {
        expenseName = description
    }
    
    func currencyValueHasChanged(currency: Double) {
        expenseValue = currency
    }
    
    func didSelectObject(object: Any) {
        guard let wallet = object as? Wallet else {
            guard let template = object as? Template else {
                return
            }
            selectedTemplate = template
            tableView.reloadData()
            return
        }
        selectedWallet = wallet
        tableView.reloadData()
    }
    
    func openCollection(collectionType: CollectionType) {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "open-expense-collection-segue") as? AddExpenseColectionViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.collectionType = collectionType
        pvc?.objectSelectionDelegate = self
        
        present(pvc ?? UIViewController(), animated: true)
    }
    
    func didTapRecurrency() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddExpenseRecurrencyViewController") as? AddExpenseRecurrencyViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.recurrencyDelegate = self
        pvc?.selectedRecurrencyType = selectedRecurrencyType
        
        present(pvc ?? UIViewController(), animated: true)
    }
    
    func didTapCalendar() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddExpenseCalendarViewController") as? AddExpenseCalendarViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.calendarDelegate = self
        pvc?.selectedDate = selectedDate
        
        present(pvc ?? UIViewController(), animated: true)
    }
    
    func sendDate(date: Date) {
        selectedDate = date
        tableView.reloadData()
    }
    
    func sendRecurrencyType(recurrencyType: RecurrencyTypes) {
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
    }
}

extension AddExpenseViewController: UIGestureRecognizerDelegate {
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
