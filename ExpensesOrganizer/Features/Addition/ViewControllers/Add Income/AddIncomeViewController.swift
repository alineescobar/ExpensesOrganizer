//
//  AddIncomeTableViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import CoreData
import UIKit

enum AddIncomeCells: CaseIterable {
    case value, divider, name, category, wallet, planning
    
    static var allCases: [AddIncomeCells] {
        [.value, .name, .divider, .category, .divider, .wallet, .divider, .planning]
    }
}

class AddIncomeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    weak var modalHandlerDelegate: ModalHandlerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var incomeValue: Double = 0.0
    private var incomeName: String = ""
    private var selectedWallet: Wallet?
    private var incomeCategory: Template?
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
            incomeCategory = templates.last
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction private func cancellButton(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneButton(_ sender: UIButton) {
        if !incomeValue.isZero && selectedWallet != nil {
            guard let context = self.context else {
                return
            }
            
            let newTransaction = Transaction(context: context)
            newTransaction.name = incomeName.isEmpty ? NSLocalizedString("Transaction", comment: "") : incomeName
            newTransaction.value = incomeValue
            newTransaction.transactionDate = selectedDate
            newTransaction.recurrenceType = selectedRecurrencyType.rawValue
            newTransaction.category = incomeCategory
            newTransaction.transactionDestination = selectedWallet?.walletID
            newTransaction.origin = nil
            newTransaction.income(objectID: selectedWallet?.walletID ?? UUID(), value: incomeValue)
            
            do {
                let request = Item.fetchRequest() as NSFetchRequest<Item>
                let namePredicate = NSPredicate(format: "name == %@", incomeName)
                let templateIDPredicate = NSPredicate(format: "template.templateID == %@", incomeCategory?.templateID?.uuidString ?? "")
                
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
                    newItem.name = incomeName
                    newItem.value = incomeValue
                    newItem.paymentMethod = selectedWallet
                    newItem.recurrenceDate = selectedDate
                    newItem.template = incomeCategory
                    
                    newItem.sendsNotification = false
                    newItem.recurrenceType = selectedRecurrencyType.rawValue
                } else {
                    let item: Item? = items.first
                    item?.value = incomeValue
                    item?.recurrenceDate = selectedDate
                    item?.recurrenceType = selectedRecurrencyType.rawValue
                    item?.paymentMethod = selectedWallet
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                try context.save()
                performSegue(withIdentifier: "open-income-alldone-segue", sender: nil)
            } catch {
                print(error.localizedDescription)
                return
            }
        } else if incomeValue.isZero && selectedWallet == nil {
            showEmptyWalletAndBalanceAlert()
        } else if incomeValue.isZero {
            showEmptyBalanceAlert()
        } else {
            showEmptyWalletAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "open-income-alldone-segue" {
            let addIncomeAllDoneViewController = segue.destination as? AddIncomeAllDoneViewController
            addIncomeAllDoneViewController?.modalHandlerDelegate = self
        }
    }
    
    func fetchAllCategories() -> [Template] {
        guard let context = self.context else {
            return []
        }
        
        var categories = [Template()]
        do {
            categories = try context.fetch(Template.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return categories
    }
    
    func fetchAllWallets() -> [Wallet] {
        guard let context = self.context else {
            return []
        }
        
        var wallets = [Wallet()]
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return wallets
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

extension AddIncomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddIncomeCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCategory = AddIncomeCells.allCases[indexPath.row]
        
        switch cellCategory {
        case .value:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeValueCell.identifier, for: indexPath) as? AddIncomeValueCell else {
                return UITableViewCell()
            }
            cell.currencyDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeNameCell.identifier, for: indexPath) as? AddIncomeNameCell else {
                return UITableViewCell()
            }
            
            cell.descriptionDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeCategoryCell.identifier, for: indexPath) as? AddIncomeCategoryCell else {
                return UITableViewCell()
            }
            cell.selectionLabel.text = incomeCategory?.name ?? NSLocalizedString("Others", comment: "")
            cell.selectionImage.image = UIImage(named: incomeCategory?.templateIconName ?? "Atom")
            cell.planningDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .wallet:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeWalletCell.identifier, for: indexPath) as? AddIncomeWalletCell else {
                return UITableViewCell()
            }
            cell.contentLabel.text = selectedWallet?.name ?? NSLocalizedString("WalletName", comment: "")
            cell.planningDelegate = self
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomePlanningCell.identifier, for: indexPath) as? AddIncomePlanningCell else {
                return UITableViewCell()
            }
            
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
            return tableView.dequeueReusableCell(withIdentifier: "add-income-divider-cell", for: indexPath)
        }
    }
}

extension AddIncomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        
        if presented is AddIncomeColectionViewController {
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

extension AddIncomeViewController: PlanningCellDelegate, RecurrencyTypeDelegate, CalendarDelegate, CollectionDelegate,
                                   ObjectSelectionDelegate, CurrencyDelegate, DescriptionDelegate, ModalHandlerDelegate {
    
    func modalDismissed() {
        modalHandlerDelegate?.modalDismissed()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func descriptionDidChanged(description: String) {
        incomeName = description
    }
    
    func currencyValueHasChanged(currency: Double) {
        incomeValue = currency
    }
    
    func didSelectObject(object: Any) {
        guard let wallet = object as? Wallet else {
            guard let template = object as? Template else {
                return
            }
            incomeCategory = template
            tableView.reloadData()
            return
        }
        selectedWallet = wallet
        tableView.reloadData()
    }
    
    func openCollection(collectionType: CollectionType) {
        if collectionType == .templates {
            let allTemplates = fetchAllCategories()
            if allTemplates.count < 1 {
                let alert = UIAlertController(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("addIncoCategoriesMessage", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Addition", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "open-income-collection-segue") as? AddIncomeColectionViewController
                
                pvc?.collectionType = collectionType
                pvc?.modalPresentationStyle = .custom
                pvc?.transitioningDelegate = self
                pvc?.objectSelectionDelegate = self
                present(pvc ?? UIViewController(), animated: true)
            }
        } else {
            let allWallets = fetchAllWallets()
            if allWallets.count < 1 {
                let alert = UIAlertController(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("addIncoCategoriesMessage", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Addition", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "open-income-collection-segue") as? AddIncomeColectionViewController
                
                pvc?.collectionType = collectionType
                pvc?.modalPresentationStyle = .custom
                pvc?.transitioningDelegate = self
                pvc?.objectSelectionDelegate = self
                present(pvc ?? UIViewController(), animated: true)
            }
        }
    }
    
    func didTapRecurrency() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddIncomeRecurrencyViewController") as? AddIncomeRecurrencyViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.recurrencyDelegate = self
        pvc?.selectedRecurrencyType = selectedRecurrencyType
        
        present(pvc ?? UIViewController(), animated: true)
    }
    
    func didTapCalendar() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddIncomeCalendarViewController") as? AddIncomeCalendarViewController
        
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

extension AddIncomeViewController: UIGestureRecognizerDelegate {
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
