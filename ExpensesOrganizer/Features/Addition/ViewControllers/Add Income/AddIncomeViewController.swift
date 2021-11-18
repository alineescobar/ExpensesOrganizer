//
//  AddIncomeTableViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

enum AddIncomeCells: CaseIterable {
    case value, divider, name, category, wallet, planning
    
    static var allCases: [AddIncomeCells] {
        [.value, .name, .divider, .category, .divider, .wallet, .divider, .planning]
    }
}

class AddIncomeViewController: UIViewController {
    
    // swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var incomeValue: Double = 0.0
    private var incomeName: String = ""
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
    }
    
    @IBAction private func cancellButton(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneButton(_ sender: UIButton) {
    }
    
    func fetchAllCategories() -> [Template] {
        var categories = [Template()]
        do {
            categories = try context.fetch(Template.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        return categories
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
            cell.valueDelegate = self
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeNameCell.identifier, for: indexPath) as? AddIncomeNameCell else {
                return UITableViewCell()
            }
            
            cell.incomeNameDelegate = self
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeCategoryCell.identifier, for: indexPath) as? AddIncomeCategoryCell else {
                return UITableViewCell()
            }
            
            cell.planningDelegate = self
            
            return cell
            
        case .wallet:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeWalletCell.identifier, for: indexPath) as? AddIncomeWalletCell else {
                return UITableViewCell()
            }
            
            cell.planningDelegate = self
            
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
            cell.recurrencyLabel.text = selectedRecurrencyType.rawValue
            
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
            presentationController.heightMultiplier = 0.5
        }
        
        return presentationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension AddIncomeViewController: PlanningCellDelegate, RecurrencyTypeDelegate, CalendarDelegate, CollectionDelegate, IncomeCaterogyDelegate {
    
    func openCollection() {
        let allTemplates = fetchAllCategories()
        print(allTemplates.count)
        if allTemplates.count < 1 {
            let alert = UIAlertController(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("addIncoCategoriesMessage", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Addition", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "open-income-collection-segue") as? AddIncomeColectionViewController
            
            pvc?.modalPresentationStyle = .custom
            pvc?.transitioningDelegate = self
            pvc?.incomeCategoryDelegate = self
            present(pvc ?? UIViewController(), animated: true)
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
    
    func sendIncomeCategory(caterogy: Template) {
        incomeCategory = caterogy
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

extension AddIncomeViewController: ValueDelegate {
    func sendValue(value: Double) {
        incomeValue = value
    }
}

extension AddIncomeViewController: IncomeNameDelegate {
    func sendIncomeName(name: String) {
        incomeName = name
    }
}
