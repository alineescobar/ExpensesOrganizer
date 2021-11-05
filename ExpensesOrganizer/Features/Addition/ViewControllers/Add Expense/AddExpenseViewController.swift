//
//  AddExpenseTableViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

enum AddExpenseCells: CaseIterable {
    case value, divider, name, category, paymentMethod, planning
    
    static var allCases: [AddExpenseCells] {
        [.value, .name, .divider, .category, .divider, .paymentMethod, .divider, .planning]
    }
}

class AddExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecurrencyTypeDelegate {
    func sendRecurrencyType(recurrencyType: RecurrencyTypes) {
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var selectedRecurrencyType: RecurrencyTypes = .never
    private var selectedDate: Date = Date()
    private let interactor = Interactor()
    private let walletCreationCategories: [WalletCreationCategory] = WalletCreationCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsSelection = false
        
        doneButton.layer.cornerRadius = 8
        cancellButton.layer.cornerRadius = 8
        cancellButton.layer.borderColor = UIColor.label.cgColor
        cancellButton.layer.borderWidth = 2.0
        
        print("\n\n\nterminal\n\n\n")
    }
    
    // MARK: - Table view data source
    
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
            
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseNameCell.identifier, for: indexPath) as? AddExpenseNameCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseCategoryCell.identifier, for: indexPath) as? AddExpenseCategoryCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .paymentMethod:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpensePaymentCell.identifier, for: indexPath) as? AddExpensePaymentCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpensePlanningCell.identifier, for: indexPath) as? AddExpensePlanningCell else {
                return UITableViewCell()            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            cell.planningDelegate = self
            cell.recurrencyLabel.text = selectedRecurrencyType.rawValue
            cell.dateLabel.text = formatter.string(from: selectedDate)
            
            return cell
            
        case .divider:
            return tableView.dequeueReusableCell(withIdentifier: "add-expense-divider-cell", for: indexPath)
        }
    }
}

extension AddExpenseViewController: UIViewControllerTransitioningDelegate {
    // TODO: mudar para default se all done
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        guard (presenting as? AddExpenseAllDoneViewController) != nil else {
//            return self.presentationController
//        }

        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension AddExpenseViewController: PlanningCellDelegate {
    func didTapRecurrency() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddExpenseRecurrencyViewController") as? AddExpenseRecurrencyViewController

        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
        pvc?.recurrencyDelegate = self
        pvc?.selectedRecurrencyType = selectedRecurrencyType

        present(pvc ?? UIViewController(), animated: true)
        
        print(#function)
    }

    func didTapCalendar() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddExpenseCalendarViewController") as? AddExpenseCalendarViewController

        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self
//        pvc?.calendarDelegate = self
//        pvc?.selectedDate = selectedDate

        present(pvc ?? UIViewController(), animated: true)
        
        print(#function)
    }
}