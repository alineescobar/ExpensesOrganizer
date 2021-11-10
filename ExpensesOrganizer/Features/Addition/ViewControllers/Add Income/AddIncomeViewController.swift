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
        tableView.allowsSelection = false
        
        doneButton.layer.cornerRadius = 8
        doneButton.titleLabel?.font = UIFont(name: "WorkSans-SemiBold", size: 16)
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)

        
        cancellButton.layer.cornerRadius = 8
        cancellButton.layer.borderColor = UIColor.label.cgColor
        cancellButton.layer.borderWidth = 2.0
        cancellButton.titleLabel?.font = UIFont(name: "WorkSans-SemiBold", size: 16)
        cancellButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
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
            
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeNameCell.identifier, for: indexPath) as? AddIncomeNameCell else {
                return UITableViewCell()
            }
            
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
            
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomePlanningCell.identifier, for: indexPath) as? AddIncomePlanningCell else {
                return UITableViewCell()
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            cell.planningDelegate = self
            cell.recurrencyLabel.text = selectedRecurrencyType.rawValue
            cell.dateLabel.text = formatter.string(from: selectedDate)
            
            return cell
            
        case .divider:
            return tableView.dequeueReusableCell(withIdentifier: "add-income-divider-cell", for: indexPath)
        }
    }
}

extension AddIncomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        guard presenting is AddIncomeColectionViewController else {
            print("\n\n\n\n ok \n\n\n\n")
            return CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController, height: 360)
        }
        
        print("\n\n\n\n !!! \n\n\n\n")
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor.hasStarted ? interactor : .none
    }
}

extension AddIncomeViewController: PlanningCellDelegate, RecurrencyTypeDelegate, CalendarDelegate, CollectionDelegate {
    
    func openCollection() {
        let storyboard = UIStoryboard(name: "Addition", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "open-income-collection-segue") as? AddIncomeColectionViewController
        
        pvc?.modalPresentationStyle = .custom
        pvc?.transitioningDelegate = self

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
